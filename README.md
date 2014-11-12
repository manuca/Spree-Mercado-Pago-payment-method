Spree Mercado Pago Payment Method
=================================

Integration of Mercado Pago with Spree 1.3

For Spree 1.2 users please check spree-1.2 branch

Installation
------------

```
gem 'spree_mercado_pago_payment_method', git: "git@github.com:manuca/Spree-Mercado-Pago-payment-method.git"
```

Usage
-----

- Add a new payment method in the admin panel of type PaymentMethod::MercadoPago
- After adding the payment method you will be able to configure your Client ID and Client Secret (provided by Mercado Pago).
- Once you received finished orders you must manually capture (or void) the order at least until IPN is implemented.

Pending Work
------------

- Portuguese translation (volunteers please take a look at localization files, there are very few strings to translate and I'll be glad to add a pt.yml to this repo).
- Implementation of IPN (Instant Payment Notification)
- Configurable currency

Testing
-------

- clone this repo
- execute `bundle`
- execute `rake test_app` to build a dummy app directory inside specs
- execute `bundle exec rspec spec`
