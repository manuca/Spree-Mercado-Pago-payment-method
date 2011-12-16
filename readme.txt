Dependencies:
=============
'rest-client'

Config
======
- Copy the files inside 'lib/' make sure they are required on initialization.
- Add Spree::Config.set(:allow_guest_checkout =>  false) because we need
  an identified user to review the cart.

Pending work
============
- Implementation of IPN (Mercado Instant Payment Notification)
- Tests (0% tests, what a shame)
- It would be great to cache somewhere (maybe payment source) the key to
  the cart options sent to Mercado Pago, currently we query their server
  each time you  generate the payment button (each time  you refresh the
  cart listing before payment) which is far from optimal but works.
