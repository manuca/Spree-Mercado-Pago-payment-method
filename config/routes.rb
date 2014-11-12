Spree::Core::Engine.add_routes do
  post '/mercado_pago', :to => "mercado_pago#checkout", :as => :mercado_pago_checkout
  get  '/mercado_pago/success', :to => "mercado_pago#success", :as => :mercado_pago_success
  get  '/mercado_pago/pending', :to => "mercado_pago#pending", :as => :mercado_pago_pending
  get  '/mercado_pago/failure', :to => "mercado_pago#failure", :as => :mercado_pago_failure
end
