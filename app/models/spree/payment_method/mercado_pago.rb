module Spree
  class PaymentMethod::MercadoPago < PaymentMethod
    preference :client_id,     :integer
    preference :client_secret, :string

    def payment_profiles_supported?
      false
    end

    def provider_class
      ::MercadoPago::Client
    end

    def provider(additional_options={})
      options = {
        sandbox: preferred_sandbox
      }
      client = provider_class.new(self, options.merge(additional_options))
      client.authenticate
      client
    end

    def auto_capture?
      false
    end

    def authorize(amount, source, gateway_options)
      status = provider.get_payment_status identifier(gateway_options[:order_id])
      success = !failed?(status)
      ActiveMerchant::Billing::Response.new(success, 'MercadoPago payment authorized', {status: status})
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end

    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      payment.state != 'void'
    end

    def capture(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def void(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end
  end
end
