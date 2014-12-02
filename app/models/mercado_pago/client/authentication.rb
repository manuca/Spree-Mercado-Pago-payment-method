require 'json'

class MercadoPago::Client
  module Authentication
    def authenticate
      response = send_authentication_request
      @auth_response = JSON.parse(response)
    rescue RestClient::Exception => e
      @errors << I18n.t(:authentication_error, scope: :mercado_pago)
      raise RuntimeError.new e.message
    end

    private

    def send_authentication_request
      RestClient.post(
        'https://api.mercadolibre.com/oauth/token',
        {:grant_type => 'client_credentials', :client_id => client_id, :client_secret => client_secret},
        :content_type => 'application/x-www-form-urlencoded', :accept => 'application/json'
      )
    end

    def client_id
      @payment_method.preferred_client_id
    end

    def client_secret
      @payment_method.preferred_client_secret
    end

    def access_token
      authenticate unless @auth_response
      @auth_response['access_token']
    end
  end
end
