class MercadoPago::Client
  module Preferences

    def create_preferences(preferences)
      response = send_preferences_request preferences
      @preferences_response = ActiveSupport::JSON.decode(response)
    rescue RestClient::Exception => e
      @errors << I18n.t(:mp_authentication_error)
      raise RuntimeError.new e.message
    end

  private



    def send_preferences_request(preferences)
      RestClient.post(preferences_url(access_token), preferences.to_json,
                    :content_type => 'application/json', :accept => 'application/json')
    end
  end
end