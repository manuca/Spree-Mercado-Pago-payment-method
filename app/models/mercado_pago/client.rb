require 'rest_client'
require 'mercado_pago/client/authentication'
require 'mercado_pago/client/preferences'
require 'mercado_pago/client/api'

module MercadoPago
  class Client
    # These three includes are because of the user of line_item_description from
    # ProductsHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::SanitizeHelper
    include Spree::ProductsHelper

    attr_reader :errors
    attr_reader :auth_response
    attr_reader :preferences_response

    def initialize(order, callbacks)
      unless callbacks[:success] && callbacks[:pending] && callbacks[:failure]
        raise "Url callbacks where not specified"
      end

      @order = order
      @callbacks = callbacks
      @errors = []
      config_options
    end

    def authenticate
      response = send_authentication_request

      if response.code != 200
        @auth_response = nil
        @errors << I18n.t(:mp_authentication_error) 
      else
        @errors = []
        @auth_response = ActiveSupport::JSON.decode(response)
      end

      @auth_response
    end

    def send_data
      response = send_preferences_request

      if response.code != 201
        @preferences_response = nil
        @errors << I18n.t(:mp_preferences_setup_error)
      else
        @errors = []
        @preferences_response = ActiveSupport::JSON.decode(response)
      end

      @preferences_response
    end

    def redirect_url
      @preferences_response["init_point"] if @preferences_response.present?
    end

    private

    def send_authentication_request
      client_id     = @order.payments.last.payment_method.preferred_client_id
      client_secret = @order.payments.last.payment_method.preferred_client_secret

      response = RestClient.post(
        'https://api.mercadolibre.com/oauth/token',
        {:grant_type => 'client_credentials', :client_id => client_id, :client_secret => client_secret},
        :content_type=> "application/x-www-form-urlencoded", :accept => 'application/json'
      )
    end
  end
end
