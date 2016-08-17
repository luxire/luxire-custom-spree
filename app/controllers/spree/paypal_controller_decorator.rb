Spree::PaypalController.class_eval do
	def express_checkout_request_details order, items
      { :SetExpressCheckoutRequestDetails => {
          :InvoiceID => order.number,
          :BuyerEmail => order.email,
          :ReturnURL => confirm_paypal_url(:payment_method_id => params[:payment_method_id], :utm_nooverride => 1),
          :CancelURL =>  "http://104.215.252.45/#/cart",
          :SolutionType => payment_method.preferred_solution.present? ? payment_method.preferred_solution : "Mark",
          :LandingPage => payment_method.preferred_landing_page.present? ? payment_method.preferred_landing_page : "Billing",
          :cppheaderimage => payment_method.preferred_logourl.present? ? payment_method.preferred_logourl : "",
          :NoShipping => 1,
          :PaymentDetails => [payment_details(items)]
      }}
    end

end
