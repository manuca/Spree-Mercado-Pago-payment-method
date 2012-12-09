# -*- encoding : utf-8 -*-
Spree::Core::Engine.routes.draw do
  get "/mercado_pago/success" => "mercado_pago#success", :as => :mercado_pago_success 
  get "/mercado_pago/pending" => "mercado_pago#pending", :as => :mercado_pago_pending 
  get "/mercado_pago/failure" => "mercado_pago#failure", :as => :mercado_pago_failure 
end
