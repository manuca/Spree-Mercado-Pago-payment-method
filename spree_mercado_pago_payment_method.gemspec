Gem::Specification.new do |s|
  s.name = 'spree_mercado_pago_payment_method'
  s.version     = '0.2.0'
  s.summary     = 'Spree plugin yo integrate Mercado Pago'
  s.description = 'Integrates Mercado Pago with Spree'
  s.author      = "Manuel Barros Reyes"
  s.files       = `git ls-files -- {app,config,lib,test,spec,features}/*`.split("\n")
  s.homepage    = 'https://github.com/manuca/Spree-Mercado-Pago-payment-method'
  s.email       = 'manuca@gmail.com'

  s.add_dependency 'spree_core', '~> 2.3.0'
  s.add_dependency 'rest-client'

  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'rspec-rails',  '~> 2.14.0'
  s.add_development_dependency 'sass-rails', '~> 4.0.4'
  s.add_development_dependency 'coffee-rails', '~> 4.1.0'
  s.add_development_dependency 'sqlite3'

  s.test_files = Dir["spec/**/*"]
end
