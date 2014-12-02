require 'json'

class MercadoPago::Client
  module Preferences
    def create_preferences(preferences)
      response = send_preferences_request(preferences)
      @preferences_response = JSON.parse(response)
    rescue RestClient::Exception => e
      @errors << I18n.t(:authentication_error, scope: :mercado_pago)
      raise RuntimeError.new(e.message)
    end

    private

    def send_preferences_request(preferences)
      RestClient.post(preferences_url(access_token), preferences.to_json,
                      :content_type => 'application/json', :accept => 'application/json')
    end
  end
end
