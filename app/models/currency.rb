class Currency < ActiveRecord::Base

CURRENCY_MULTIPLIER_FOR_SWATCH = {"EUR"=>1, "AUD"=>2, "SGD"=>2, "NOK"=>10, "DKK"=>10, "SEK"=>10, "CHF"=>1, "INR"=>100, "GBP"=>1, "CAD"=>1}

# populate() is a class method which is used to fetch the value of Currency from Apilayer
# And populate the currency table.
      def self.populate
        url = URI.parse('http://apilayer.net/api/live?access_key=a917a3d6244742e74dacea1ec2e29940&currencies=EUR,AUD,SGD,NOK,DKK,SEK,CHF,FIM,INR,DBP,GBP,CAD&source=USD&format=1')
        req = Net::HTTP::Get.new(url.to_s)
        res = Net::HTTP.start(url.host, url.port) { |http|
        http.request(req)
        }
        response_hash =  eval(res.body)
        currency_hash = {fetched_date: Date.today}
        begin
          currency = Currency.find(Date.today)
        rescue Exception
          logger.debug "No record available for the day"
        end
        if currency
          currency.value = response_hash[:quotes].transform_keys {|key| key[3 ... key.length].to_sym}
        else
          currency_hash[:value] = response_hash[:quotes].transform_keys {|key| key[3 ... key.length].to_sym}
          currency = Currency.new(currency_hash)
        end
        currency.save
      end

# Once we get the new currency multiplier, we should update the prices table
# update_prices() will update the price table with the new currency multiplier.
# update_prices() will not update the prices of gift card product.
      def update_prices
        get_currency_multiplier
        # Return if currency is not available
        return if @currency_multiplier.nil?
        # Get all the variant except gift card one.
        variants = Spree::Variant.joins(:product).where("spree_products.is_gift_card =? and spree_variants.sku not like ?", false, "SWT%")
        variants.each do |variant|
          @usd_price = variant.prices.where(currency: "USD").take.amount
          @currency_multiplier.keys.each do |key|
            updated_price = variant.prices.where(currency: key).take
            # Round off the amount to next 5 and substract .1 from it
            amount = get_price(key)
            updated_price.amount = amount
            updated_price.save!
          end
        end
      end

# create_prices() is similar to update_prices().
# create_prices() is used for intial upload.
      def create_prices
          get_currency_multiplier
          # Return if currency is not available
          return if @currency_multiplier.nil?
          create_swatch_variant_prices_for_all_currency
          # Get all the variant except gift card and Swatch.
          variants = Spree::Variant.joins(:product).where("spree_products.is_gift_card =? and spree_variants.sku not like ?", false, "SWT%")
          variants.each do |variant|
            @usd_price = variant.prices.where(currency: "USD").take.amount
            @currency_multiplier.keys.each do |key|
              price_exist = variant.prices.where(currency: key).take
              unless price_exist
                create_variant_price = Spree::Price.new
                create_variant_price.variant = variant
                create_variant_price.currency = key
                # Round off the amount to next 5 and substract .1 from it
                amount = get_price(key)
                create_variant_price.amount = amount
                create_variant_price.save!
              end
            end
          end
        end

# Once the prices of the variant are updated all the line_items prices where the order is not completed should also be updated.
# update_orders() method update the price of the line_items prices where the order is not complete.
# This is very specific to customer requirement.
      def update_orders
        # Get all the order which is not completed
        orders = Spree::Order.where(completed_at:nil)
        # Iterate over the order object, update the line_items, personalization cost.
        orders.each do |order|
          begin
            order.transaction do
              order.line_items.each do |line_item|
                price = line_item.variant.prices.where(currency: line_item.currency).take
                line_item.price = price.amount
                # Update personalization
                personalization_adjustment = line_item.adjustments.where(source_type: "PersonalizationCost").take
                if personalization_adjustment
                  update_personalization_cost(line_item, order)
                end
                line_item.save!
              end
              order.update!
            end
          rescue Exception => e
            logger.error "Can't update price because of #{e.message}"
          end
        end
      end

# update_order_currency() will update the currency of the order. This is basically used to update the
# order in the cart
    def update_order_currency(order, updated_currency)
      adjustments = Spree::Adjustment.where(order: order , source_type: "PersonalizationCost", adjustable_type: "Spree::LineItem")
      adjustments.each do |adjustment|
        line_item = adjustment.adjustable
        update_personalization_cost(line_item, order)
      end
        order.currency = updated_currency
        order
    end

# et_price_for_other_currency method converts a price to its equivalent in other currency
    def get_price_for_other_currency(price,current_currency, updated_currency)
      get_currency_multiplier
      if current_currency == "USD"
        @currency_multiplier[updated_currency] * price
      elsif updated_currency == "USD"
        (price/@currency_multiplier[current_currency])
      else
        (price/@currency_multiplier[current_currency]) * @currency_multiplier[updated_currency]
      end
    end

    def update_product_currency(products)
      get_currency_multiplier
      products.each do |id|
        product = Spree::Product.find(id)
        variants = product.variants
        variants.each do |variant|
          @multiplier = {}
          @usd_price = variant.prices.where(currency: "USD").take.amount
          if variant.sku.include?("SWT")
            @multiplier = CURRENCY_MULTIPLIER_FOR_SWATCH
          else
            @multiplier = @currency_multiplier
          end
          @multiplier.keys.each do |key|
            updated_price = variant.prices.where(currency: key).take
            if @multiplier == @currency_multiplier
              # Round off the amount to next 5 and substract .1 from it
              amount = get_price(key)
            else
              amount = @usd_price * CURRENCY_MULTIPLIER_FOR_SWATCH[key]
            end
            updated_price.amount = amount
            updated_price.save!
          end
        end
      end
    end

    def create_product_currency(products)
      get_currency_multiplier
      products.each do |id|
        product = Spree::Product.find(id)
        variants = product.variants
        variants.each do |variant|
          @multiplier = {}
          @usd_price = variant.prices.where(currency: "USD").take.amount
          if variant.sku.include?("SWT")
            @multiplier = CURRENCY_MULTIPLIER_FOR_SWATCH
          else
            @multiplier = @currency_multiplier
          end
          @multiplier.keys.each do |key|
            price_exist = variant.prices.where(currency: key).take
            unless price_exist
              create_variant_price = Spree::Price.new
              create_variant_price.variant = variant
              create_variant_price.currency = key
              if @multiplier == @currency_multiplier
                # Round off the amount to next 5 and substract .1 from it
                amount = get_price(key)
              else
                amount = @usd_price * CURRENCY_MULTIPLIER_FOR_SWATCH[key]
              end
              create_variant_price.amount = amount
              create_variant_price.save!
            end
          end
        end
      end
    end

private
# get_price method gets the price of a variant in a specific currency and also do a round off.
      def get_price(key)
        amount = @usd_price * @currency_multiplier[key]
        amount = (amount - amount % 5 + 4.99).round(2)
      end

# update_personalization_cost method will update the personalization cost, if a line_item has an associated
# personalization cost
      def update_personalization_cost(line_item, order)
          luxire_line_item = line_item.luxire_line_item
          personalization_cost = luxire_line_item.total_personalisation_cost_in_currencies[order.currency]
          personalization_adjustment.amount = personalization_cost
          personalization_adjustment.save!
          # Update personalization cost source
          source = personalization_adjustment.source
          source.cost = personalization_cost
          source.save!
      end

# get_currency_multiplier() fetches the multiplier for different currency
      def get_currency_multiplier
        begin
          currencies = Currency.last
          @currency_multiplier = currencies.value
        rescue Exception => e
          logger.error "Not able to fetch #{Date.today} currency record due to #{e.message} "
        end
      end

      def create_swatch_variant_prices_for_all_currency
        variants = Spree::Variant.joins(:product).where("spree_products.is_gift_card =? and spree_variants.sku like ?", false, "SWT%")
        variants.each do |variant|
          usd_price = variant.prices.where(currency: "USD").take.amount
          CURRENCY_MULTIPLIER_FOR_SWATCH.keys.each do |key|
            price_exist = variant.prices.where(currency: key).take
            unless price_exist
              create_variant_price = Spree::Price.new
              create_variant_price.variant = variant
              create_variant_price.currency = key
              amount = usd_price * CURRENCY_MULTIPLIER_FOR_SWATCH[key]
              create_variant_price.amount = amount
              create_variant_price.save!
            end
          end
        end
      end
end
