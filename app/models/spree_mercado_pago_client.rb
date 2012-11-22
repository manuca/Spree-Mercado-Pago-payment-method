# -*- encoding : utf-8 -*-
require 'rest_client'

class SpreeMercadoPagoClient
  def initialize(order, callbacks)
    unless callbacks[:success] && callbacks[:pending] && callbacks[:failure]
      raise "Url callbacks where not specified"
    end

    @order = order
    @callbacks = callbacks
    config_options
  end

  def authenticate
    response = send_authentication_request

    if response.code != 200
      @auth_response = nil
      raise I18n.t(:mp_authentication_error) 
    else
      @auth_response = ActiveSupport::JSON.decode(response)
    end
  end

  def send_data
    response = send_preferences_request

    if response.code != 201
      @config_response = nil
      raise I18n.t(:mp_preferences_setup_error)
    else
      @config_response = ActiveSupport::JSON.decode(response)
    end
  end

  private
  def send_authentication_request
    client_id     = @order.payment_method.preferred_client_id
    client_secret = @order.payment_method.preferred_client_secret

    response = RestClient.post(
      'https://api.mercadolibre.com/oauth/token',
      {:grant_type => 'client_credentials', :client_id => client_id, :client_secret => client_secret},
      :content_type=> "application/x-www-form-urlencoded", :accept => 'application/json'
    )
  end

  def send_preferences_request
    RestClient.post(
      mp_preferences_url(@auth_response["access_token"]),
      @options.to_json,
      :content_type=> 'application/json', :accept => 'application/json'
    )
  end

  def mp_preferences_url(token)
    "https://api.mercadolibre.com/checkout/preferences?access_token=#{token}"
  end
  
  def config_options
    @options = Hash.new
    @options[:external_reference] = @order.number
    @options[:back_urls] = {
      :success => @callbacks[:success],
      :pending => @callbacks[:pending],
      :failure => @callbacks[:failure]
    }
    @options[:items] = Array.new

    @order.line_items.each do |li| 
      h = {
        :title => li.description,
        :unit_price => li.price.to_f,
        :quantity => li.quantity,
        :currency_id => "ARS"
      }
      @options[:items] << h
    end
  end
end
