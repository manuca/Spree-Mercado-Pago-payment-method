# -*- encoding : utf-8 -*-
Spree::CheckoutController.class_eval do
  before_filter :redirect_to_mercado_pago_button_if_needed, :only => [:update]

  def redirect_to_mercado_pago_button_if_needed
    return unless params[:state] == "payment"
    @payment_method = Spree::PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])

    if @payment_method && @payment_method.kind_of?(PaymentMethod::MercadoPago)
      @order.update_attributes(object_params)
      render :text => @order.to_json
      # redirect_to mercado_pago_button_path(:order_number => @order.number)
    end
  end
end
