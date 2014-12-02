Spree Mercado Pago Payment Method
=================================

Integration of Mercado Pago with Spree 2.3

For Spree 1.3 - Take a look a spree-1.3 branch  
For Spree 1.2 - Take a look a spree-1.2 branch

Installation
------------

```
gem 'spree_mercado_pago_payment_method', git: "git@github.com:manuca/Spree-Mercado-Pago-payment-method.git"
```

Usage
-----

- Add a new payment method in the admin panel of type Spree::PaymentMethod::MercadoPago
- After adding the payment method you will be able to configure your Client ID and Client Secret (provided by Mercado Pago).

IPN
---

For IPN you need to configure the notification URL in Mercado Pago's site. The notification URL will be `http[s]://[your_domain]/mercado_pago/ipn`. Please review Mercado Pago's documentation at http://developers.mercadopago.com/ for the correct place where to configure IPN notification URLs.


Pending Work
------------

- Portuguese translation (volunteers please take a look at localization files, there are very few strings to translate and I'll be glad to add a pt.yml to this repo).
- Configurable currency

Testing
-------

- clone this repo
- execute `bundle`
- execute `rake test_app` to build a dummy app directory inside specs
- execute `bundle exec rspec spec`
