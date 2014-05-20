# -*- encoding : utf-8 -*-
require 'rest_client'
require 'mercado_pago/client/authentication'
require 'mercado_pago/client/preferences'
require 'mercado_pago/client/api'

module MercadoPago

class Client
  # These three includes are because of the user of line_item_description from
  # ProductsHelper

  include Authentication
  include Preferences
  include API


  attr_reader :errors
  attr_reader :auth_response
  attr_reader :preferences_response

  def initialize(payment_method, options={})
    @payment_method = payment_method
    @api_options = options.clone
    @errors = []
  end


  def get_external_reference(mercado_pago_id)
    response = send_notification_request mercado_pago_id
    if response
      response['collection']['external_reference']
    end
  end

  def get_payment_status(external_reference)
    response = send_search_request({:external_reference => external_reference, :access_token => access_token})

    if response['results'].empty?
      "pending"
    else
      response['results'][0]['collection']['status']
    end
  end

  private


  def log_error(msg, response, request, result)
    Rails.logger.info msg
    Rails.logger.info "response: #{response}."
    Rails.logger.info "request args: #{request.args}."
    Rails.logger.info "result #{result}."
  end

  def send_notification_request(mercado_pago_id)
    url = create_url(notifications_url(mercado_pago_id), access_token: access_token)
    options = {:content_type => 'application/x-www-form-urlencoded', :accept => 'application/json'}
    get(url, options, quiet: true)
  end

  def send_search_request(params, options={})
    url = create_url(search_url, params)
    options = {:content_type => 'application/x-www-form-urlencoded', :accept => 'application/json'}
    get(url, options)
  end
end

end