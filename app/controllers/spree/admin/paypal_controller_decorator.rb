Spree::PaypalController.class_eval do
  respond_to :html, :json

   def express
     @spree_order = Spree::Order.find(params[:order_id])
     order = @spree_order || raise(ActiveRecord::RecordNotFound)
     # order = @spree_order || raise(ActiveRecord::RecordNotFound)
     items = order.line_items.map(&method(:line_item))

     additional_adjustments = order.all_adjustments.additional
     tax_adjustments = additional_adjustments.tax
     shipping_adjustments = additional_adjustments.shipping

     additional_adjustments.eligible.each do |adjustment|
       next if (tax_adjustments + shipping_adjustments).include?(adjustment)
       items << {
         :Name => adjustment.label,
         :Quantity => 1,
         :Amount => {
           :currencyID => order.currency,
           :value => adjustment.amount
         }
       }
     end

     # Because PayPal doesn't accept $0 items at all.
     # See #10
     # https://cms.paypal.com/uk/cgi-bin/?cmd=_render-content&content_ID=developer/e_howto_api_ECCustomizing
     # "It can be a positive or negative value but not zero."
     items.reject! do |item|
       item[:Amount][:value].zero?
     end
     pp_request = provider.build_set_express_checkout(express_checkout_request_details(order, items))

     begin
       pp_response = provider.set_express_checkout(pp_request)
       if pp_response.success?
         # find the redirected url
         paypal_order_token = PaypalTokenOrder.new
         paypal_order_token[:token] = pp_response.token
         paypal_order_token[:order_id] = @spree_order.id
         unless paypal_order_token.save
           response = { msg: "Exception while populating paypal_order_token " }
           render json: response.to_json, status: "422"
           return
         end
         redirect_url = provider.express_checkout_url(pp_response, :useraction => 'commit', num: @encrypted_data)
         # redirect_to provider.express_checkout_url(pp_response, :useraction => 'commit')
         render text: redirect_url, status: "200"
       else
         # flash[:error] = Spree.t('flash.generic_error', :scope => 'paypal', :reasons => pp_response.errors.map(&:long_message).join(" "))
         # redirect_to checkout_state_path(:payment)
         response = { msg: "Exception while processing paypal payment" }
         render json: response.to_json, status: "422"
       end
     rescue SocketError
       # flash[:error] = Spree.t('flash.connection_failed', :scope => 'paypal')
       # redirect_to checkout_state_path(:payment)
       response = { msg: "Error while connecting to payment gateway " }
       render json: response.to_json, status: "422"
     end
   end

   def confirm
     paypal_order_tokens = PaypalTokenOrder.where(token: params[:token])
     unless paypal_order_tokens.empty?
       paypal_order_token = paypal_order_tokens.first
       @spree_order = Spree::Order.find(paypal_order_token.order_id)
     else
       response = { msg: "No order exist"}
       logger.error "unable to fetch order"
       return
     end
     # order = @spree_order || raise(ActiveRecord::RecordNotFound)
     order = @spree_order
     order.payments.create!({
       :source => Spree::PaypalExpressCheckout.create!({
         :token => params[:token],
         :payer_id => params[:PayerID]
       }),
       :amount => order.total,
       :payment_method => payment_method,
       :response_code =>  params[:token]
     })
     order.next
     if order.complete?
     # return_url = "http://test.luxire.com:9000/#/invoice/#{order[:number]}?token=#{order[:guest_token]}"
     return_url = ENV['FRONTEND_HOST'] + "/#/invoice/#{order[:number]}?token=#{order[:guest_token]}"
       # flash.notice = Spree.t(:order_processed_successfully)
       # flash[:order_completed] = true
       session[:order_id] = nil
       # respond_with(order, default_template: 'Spree::Api::Orders::show', status: 200)
       # redirect_to completion_route(order)
       redirect_to return_url
     else
       # redirect_to checkout_state_path(order.state)
       response = { msg: "failed", reason: " Unable to complete order "}
       redirect_to "#{return_url}?#{response.to_json}"
     end
   end

   def cancel
     # flash[:notice] = Spree.t('flash.cancel', :scope => 'paypal')
     # order = @spree_order || raise(ActiveRecord::RecordNotFound)
     # redirect_to checkout_state_path(order.state, paypal_cancel_token: params[:token])
    #  response = { msg: "Order is cancelled"}
    #  render json: response.to_json, status: "200"
     redirect_url = ENV['FRONTEND_HOST'] + "/#/checkout/payment"
     redirect_to redirect_url
   end

   private

   def line_item(item)
     {
         :Name => item.product.name,
         :Number => item.variant.sku,
         :Quantity => item.quantity,
         :Amount => {
             :currencyID => item.order.currency,
             :value => item.price
         },
         :ItemCategory => "Physical"
     }
   end

   def express_checkout_request_details order, items
     { :SetExpressCheckoutRequestDetails => {
         :InvoiceID => order.number,
         :BuyerEmail => order.email,
         :ReturnURL => confirm_paypal_url(:payment_method_id => params[:payment_method_id], :utm_nooverride => 1),
         :CancelURL =>  cancel_paypal_url,
         :SolutionType => payment_method.preferred_solution.present? ? payment_method.preferred_solution : "Mark",
         :LandingPage => payment_method.preferred_landing_page.present? ? payment_method.preferred_landing_page : "Billing",
         :cppheaderimage => payment_method.preferred_logourl.present? ? payment_method.preferred_logourl : "",
         :NoShipping => 1,
         :PaymentDetails => [payment_details(items)]
     }}
   end

   def payment_method
     Spree::PaymentMethod.find(params[:payment_method_id])
   end

   def provider
     payment_method.provider
   end

   def payment_details items
     # This retrieves the cost of shipping after promotions are applied
     # For example, if shippng costs $10, and is free with a promotion, shipment_sum is now $10
     shipment_sum = @spree_order.shipments.map(&:discounted_cost).sum

     # This calculates the item sum based upon what is in the order total, but not for shipping
     # or tax.  This is the easiest way to determine what the items should cost, as that
     # functionality doesn't currently exist in Spree core
     item_sum = @spree_order.total - shipment_sum - @spree_order.additional_tax_total

     if item_sum.zero?
       # Paypal does not support no items or a zero dollar ItemTotal
       # This results in the order summary being simply "Current purchase"
       {
         :OrderTotal => {
           :currencyID => @spree_order.currency,
           :value => @spree_order.total
         }
       }
     else
       {
         :OrderTotal => {
           :currencyID => @spree_order.currency,
           :value => @spree_order.total
         },
         :ItemTotal => {
           :currencyID => @spree_order.currency,
           :value => item_sum
         },
         :ShippingTotal => {
           :currencyID => @spree_order.currency,
           :value => shipment_sum,
         },
         :TaxTotal => {
           :currencyID => @spree_order.currency,
           :value => @spree_order.additional_tax_total
         },
         :ShipToAddress => address_options,
         :PaymentDetailsItem => items,
         :ShippingMethod => "Shipping Method Name Goes Here",
         :PaymentAction => "Sale"
       }
     end
   end

   def address_options
     return {} unless address_required?

     {
         :Name => @spree_order.bill_address.try(:full_name),
         :Street1 => @spree_order.bill_address.address1,
         :Street2 => @spree_order.bill_address.address2,
         :CityName => @spree_order.bill_address.city,
         :Phone => @spree_order.bill_address.phone,
         :StateOrProvince => @spree_order.bill_address.state_text,
         :Country => @spree_order.bill_address.country.iso,
         :PostalCode => @spree_order.bill_address.zipcode
     }
   end

   def completion_route(order)
     order_path(order)
   end

   def address_required?
     payment_method.preferred_solution.eql?('Sole')
   end

   # def encrypt(order)
   #  crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
   #  @encrypted_data = crypt.encrypt_and_sign(order.id)
   # end

   # def decrypted(encrypted_data)
   #  crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
   #  @decrypted_back = crypt.decrypt_and_verify(encrypted_data)
   # end

 end
