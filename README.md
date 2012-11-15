Work in progress to integrate Mercado Pago with Spree 1.2

CONFIG
======

Add this to your Gemfile:

```
gem 'spree_mercado_pago_payment_method', git: "github.com/manuca/Spree-Mercado-Pago-payment-method.git"
```

PENDING WORK
============

- Implementation of IPN (Mercado Instant Payment Notification)
- Tests (0% tests, what a shame)
- It would be great to cache somewhere (maybe payment source) the key to
  the cart options sent to Mercado Pago, currently we query their server
  each time you  generate the payment button (each time  you refresh the
  cart listing before payment) which is far from optimal but works.
