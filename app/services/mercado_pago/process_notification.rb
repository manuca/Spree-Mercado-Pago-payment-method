# Process notification:
# ---------------------
# Fetch collection information
# Find payment by external reference
# If found
#   Update payment status
#   Notify user
# If not found
#   Ignore notification (maybe payment from outside Spree)
module MercadoPago
  class ProcessNotification
    # Equivalent payment states
    # MP state => Spree state
    # =======================
    #
    # approved     => complete
    # pending      => pend
    # in_process   => pend
    # rejected     => failed
    # refunded     => void
    # cancelled    => void
    # in_mediation => pend
    # charged_back => void
    STATES = {
      complete: %w(approved),
      failure: %w(rejected),
      void:    %w(refunded cancelled charged_back)
    }

    attr_reader :notification

    def initialize(notification)
      @notification = notification
    end

    def process!
      client = ::Spree::PaymentMethod::MercadoPago.provider
      op_info = client.get_operation_info(notification.operation_id)["collection"]

      if payment = Spree::Payment.where(identifier: op_info["external_reference"]).first
        if STATES[:complete].include?(op_info["status"])
          payment.complete
        elsif STATES[:failure].include?(op_info["status"])
          payment.failure
        elsif STATES[:void].include?(op_info["status"])
          payment.void
        end

        # When Spree issue #5246 is fixed we can remove this line
        payment.order.updater.update
      end
    end
  end
end
