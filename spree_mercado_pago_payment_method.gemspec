# encoding: UTF-8
Gem::Specification.new do |s|
  s.name = 'spree_mercado_pago_payment_method'
  s.version     = '0.0.2'
  s.summary     = 'Plugin to integrate Spree 1.2 with Mercado Pago'
  s.description = 'Integrates Mercado Pago with Spree'
  s.author      = "Manuel Barros Reyes"
  s.files       = `git ls-files -- {app,config,lib,test,spec,features}/*`.split("\n")
  s.homepage    = 'https://github.com/manuca/Spree-Mercado-Pago-payment-method'
  s.email       = 'manuca@gmail.com'

  s.add_dependency 'spree_core', '~> 1.2.0'
  s.add_dependency 'rest-client'

  s.add_development_dependency 'capybara', '1.1.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'rspec-rails',  '~> 2.11.0'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'spork'

  s.test_files = Dir["spec/**/*"]
end
