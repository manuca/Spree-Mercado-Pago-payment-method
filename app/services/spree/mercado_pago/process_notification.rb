# Payment states
# Spree state => MP state
# =======================
# approved     => complete
# pending      => pend
# in_process   => pend
# rejected     => failure
# refunded     => void
# cancelled    => void
# in_mediation => pend
# charged_back => void
#
# Process notification:
# ---------------------
#
# Fetch collection information
# Find payment by external reference
# If found
#   Serialize collection information
#   Update payment status
#   if approved assign source with collection info
#   payment.complete!
#   Find order associated to payment
#   Due to Spree issue #5246 order status needs to be updated by hand
#   @order.updater.update
#   Notify user
# If not found
#   Ignore notification (maybe payment from outside Spree)
module Spree
  module MercadoPago
    class ProcessNotification
      def initialize(notification)
        @notification = notification
      end

      def process!
      end
    end
  end
end
