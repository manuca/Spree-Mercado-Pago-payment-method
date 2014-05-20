class MercadoPago::Client
  module Preferences

    def create_preferences(order, payment, success_callback,
        pending_callback, failure_callback)
      options = create_preference_options order, payment, success_callback,
                                          pending_callback, failure_callback
      response = send_preferences_request options
      @preferences_response = ActiveSupport::JSON.decode(response)
    rescue RestClient::Exception => e
      @errors << I18n.t(:mp_authentication_error)
      raise RuntimeError.new e.message
    end

  private

    def create_preference_options(order, payment, success_callback,
        pending_callback, failure_callback)
      options = Hash.new
      options[:external_reference] = payment.identifier
      options[:back_urls] = {
          :success => success_callback,
          :pending => pending_callback,
          :failure => failure_callback
      }
      options[:items] = Array.new

      payer_options = @api_options[:payer]

      options[:payer] = payer_options if payer_options

      order.line_items.each do |li|
        h = {
            :title => line_item_description_text(li.variant.product.description),
            :unit_price => li.price.to_f,
            :quantity => li.quantity,
            :currency_id => 'ARS'
        }
        options[:items] << h

      end

      options[:items] << {
          :title => 'Costo de envío',
          :unit_price => order.ship_total.to_f,
          :quantity => 1,
          :currency_id => 'ARS'
      }
      options
    end



    def send_preferences_request(options)
      RestClient.post(preferences_url(access_token), options.to_json,
                    :content_type => 'application/json', :accept => 'application/json')
    end
  end
end