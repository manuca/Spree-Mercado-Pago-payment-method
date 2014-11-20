Spree::Core::Engine.add_routes do
  post '/mercado_pago/checkout', to: "mercado_pago#checkout", as: :mercado_pago_checkout
  get  '/mercado_pago/success', to: "mercado_pago#success", as: :mercado_pago_success
  get  '/mercado_pago/failure', to: "mercado_pago#failure", as: :mercado_pago_failure
  post '/mercado_pago/ipn', to: "mercado_pago#ipn", as: :mercado_pago_ipn
end
