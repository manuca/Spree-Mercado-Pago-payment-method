module Spree
  class MercadoPagoController < StoreController
    protect_from_forgery except: :ipn
    skip_before_filter :set_current_order, only: :ipn

    def checkout
      current_order.state_name == :payment || raise(ActiveRecord::RecordNotFound)
      payment_method = PaymentMethod::MercadoPago.find(params[:payment_method_id])
      payment = current_order.payments.
        create!({amount: current_order.total, payment_method: payment_method})
      payment.started_processing!

      preferences = ::MercadoPago::OrderPreferencesBuilder.
        new(current_order, payment, callback_urls).
        preferences_hash

      provider = payment_method.provider
      provider.create_preferences(preferences)

      redirect_to provider.redirect_url
    end

    # Success/pending callbacks are currently aliases, this may change
    # if required.
    def success
      payment.pend!
      payment.order.next
      flash.notice = Spree.t(:order_processed_successfully)
      flash['order_completed'] = true
      redirect_to spree.order_path(payment.order)
    end

    def failure
      payment.failure!
      flash.notice = Spree.t(:payment_processing_failed)
      flash['order_completed'] = true
      redirect_to spree.checkout_state_path(state: :payment)
    end

    def ipn
      notification = MercadoPago::Notification.
        new(operation_id: params[:id], topic: params[:topic])

      if notification.save
        MercadoPago::HandleReceivedNotification.new(notification).process!
        status = :ok
      else
        status = :bad_request
      end

      render nothing: true, status: status
    end

    private

    def payment
      @payment ||= Spree::Payment.where(identifier: params[:external_reference]).
        first
    end

    def callback_urls
      @callback_urls ||= {
        success: mercado_pago_success_url,
        pending: mercado_pago_success_url,
        failure: mercado_pago_failure_url
      }
    end
  end
end
