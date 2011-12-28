require 'rest_client'

class MercadoPagoController < Spree::BaseController
  before_filter :get_order, :only => [:show]

  def show
    # Pending
    # Check login with Devise
    
    # Get tokens, configure options, etc
    config_mercado_pago
  end

  def success
  end

  def pending
  end

  private
  def get_order
    session.delete(:order_id)
    @order = current_user.orders.find_by_number(params[:order_number])
    # @order = current_order

    unless @order && (@order.state == 'payment' || @order.state == 'complete') && @order.payment_method.is_a?(PaymentMethod::MercadoPago)
      redirect_to checkout_state_path(@order.state) and return if @order.present?
      redirect_to root_path
    end

    # @order.update_attribute(:state, "complete")
    while @order.state != "complete"
      @order.next
    end
  end

  def config_mercado_pago
    get_token
    config_options
    send_config_options
  end

  def send_config_options
    response = RestClient.post "https://api.mercadolibre.com/checkout/preferences?access_token=#{@response_object["access_token"]}",
    @config_options.to_json,
      :content_type=> 'application/json', :accept => 'application/json'

    raise "No se pudieron configurar las opciones de pedido con MP" if response.code != 201
    @config_response = ActiveSupport::JSON.decode(response)
  end

  def config_options
    @config_options = Hash.new
    @config_options[:external_reference] = @order.number
    @config_options[:back_urls] = {:success => mercado_pago_success_url, :pending => mercado_pago_pending_url, :failure => mercado_pago_failure_url}
    @config_options[:items] = Array.new

    @order.line_items.each do |li| 
      h = {
        :title => li.description,
        :unit_price => li.price.to_f,
        :quantity => li.quantity,
        :currency_id => "ARS"
      }
      @config_options[:items] << h
    end
  end

  def get_token
    client_id     = @order.payment_method.preferred_client_id
    client_secret = @order.payment_method.preferred_client_secret

    response = RestClient.post 'https://api.mercadolibre.com/oauth/token',
      {:grant_type => 'client_credentials', :client_id => client_id, :client_secret => client_secret},
      :content_type=> "application/x-www-form-urlencoded", :accept => 'application/json'

    raise "No fue posible contactarse con MercadoPago para realizar la autenticación" if response.code != 200
    @response_object = ActiveSupport::JSON.decode(response)
  end
end
