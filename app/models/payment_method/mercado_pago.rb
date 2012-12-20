# -*- encoding : utf-8 -*-
class PaymentMethod::MercadoPago < Spree::PaymentMethod
  attr_accessible :preferred_client_id, :preferred_client_secret

  preference :client_id,     :integer
  preference :client_secret, :string

  def payment_profiles_supported?
    false
  end

  def actions
    %w{capture void}
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
