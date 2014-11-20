# Process notification:
# Fetch/check payment by external reference
# If found
#   Serialize collection information
#   Check payment status
#   Update payment status to complete state if payed and collection data as payment
#   source
#   payment.complete!
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
