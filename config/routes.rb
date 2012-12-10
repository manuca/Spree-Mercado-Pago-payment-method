# -*- encoding : utf-8 -*-
Spree::Core::Engine.routes.draw do
  scope "/mercado_pago", controller: :mercado_pago do
    get :success, as: :mercado_pago_success 
    get :pending, as: :mercado_pago_pending 
    get :failure, as: :mercado_pago_failure 
  end
end
