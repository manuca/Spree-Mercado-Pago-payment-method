Dependencies:
=============
'rest-client'

Config
======
- Copy the files inside 'lib/' make sure they are required on initialization.
- Add Spree::Config.set(:allow_guest_checkout =>  false) because we need
  an identified user to review the cart.
- In my app I did an override of /app/views/users/show.html.erb so that pending payments of this payment method
  can be payed (with a link to the mercado_pago_button route) if you need this take a look at: https://gist.github.com/1486666

Pending work
============
- Implementation of IPN (Mercado Instant Payment Notification)
- Tests (0% tests, what a shame)
- It would be great to cache somewhere (maybe payment source) the key to
  the cart options sent to Mercado Pago, currently we query their server
  each time you  generate the payment button (each time  you refresh the
  cart listing before payment) which is far from optimal but works.
