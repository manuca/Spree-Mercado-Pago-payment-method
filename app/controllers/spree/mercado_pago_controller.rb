module Spree
  class MercadoPagoController < StoreController
    # Order must be in payment state
    # Find payment method
    # Create Payment for this order with current payment method
    # Send preferences to MP
    # Pass payment to processing state
    # Redirect to MP init point
    def checkout
      current_order.state_name == :payment || raise(ActiveRecord::RecordNotFound)
      payment_method = PaymentMethod::MercadoPago.find(params[:payment_method_id])
      payment = current_order.payments.create!({amount: current_order.total, payment_method: payment_method})
      payment.started_processing!

      preferences = ::MercadoPago::OrderPreferencesBuilder.
        new(current_order, payment, callback_urls).
        preferences_hash

      provider = payment_method.provider
      provider.create_preferences(preferences)

      redirect_to provider.redirect_url
    end

    def success
      # Fetch payment by external reference
      # Pass payment to pending state
      # Flash success & redirect to order detail
      payment = Spree::Payment.where(identifier: params[:external_reference]).first
      # @current_order = nil if current_order == payment.order
      payment.pend!
      flash.notice = Spree.t(:order_processed_successfully)
      flash['order_completed'] = true
      redirect_to spree.order_path(payment.order)
    end

    def pending
      # Fetch payment by external reference
      # Pass payment to pending state
      # Flash success with pending order
      # Redirect to order list
    end

    def failure
      # Fetch payment by external reference
      # Pass payment to failed state
      # Flash error
      # Redirect to checkout state payment
    end

    def ipn
      # Fetch payment by external reference
      # Fetch payment status from MP
      # Update payment status to complete if payed and assign payment info as payment source
      # payment.complete!
      # Notify user
    end

    private

    def callback_urls
      @callback_urls ||= {
        success: mercado_pago_success_url,
        pending: mercado_pago_pending_url,
        failure: mercado_pago_failure_url
      }
    end

    # def create_preferences(mp_payment)
    #   preferences = create_preference_options(current_order, mp_payment, get_back_urls)
    #   Rails.logger.info "Sending preferences to MercadoPago"
    #   Rails.logger.info "#{preferences}"
    #   provider.create_preferences(preferences)
    # end

    # def create_preference_options(order, payment, callbacks)
    #   builder = MercadoPago::OrderPreferencesBuilder.new order, payment, callbacks, payer_data

    #   return builder.preferences_hash
    # end


    # def render_result(current_state)
    #   process_payment current_payment
    #   if success_order? and current_state != :success
    #     redirect_to_state :success
    #   end
    #   if failed_payment? and current_state != :failure
    #     redirect_to_state :failure
    #   end
    #   if pending_payment? and current_state != :pending
    #     redirect_to_state :pending
    #   end

    # end

    # def payment_method
    #   @payment_method ||= ::PaymentMethod::MercadoPago.find (params[:payment_method_id])
    # end

    # Get payer info for sending within Mercado Pago request
    def payer_data
      @order ? {payer: {email: @order.email}} : {}
    end

    def provider
      @provider ||= payment_method.provider({payer: payer_data})
    end

    # def advance_state
    #   @order.update_attributes( { :state => "complete", :completed_at => Time.now },
    #                            :without_protection => true)
    # end

    # def get_order
    #   user = spree_current_user
    #   order_no = params[:order_number]
    #   @order = Order.where(number: order_no).where(user_id: user.id).first

    #   unless @order && correct_order_state
    #     if @order.present?
    #       redirect_to checkout_state_path(@order.state)
    #     else
    #       flash[:error] = I18n.t(:mp_invalid_order)
    #       redirect_to root_path
    #     end
    #     return
    #   end
    # end

    # def success
    #   advance_state
    # end

    # def pending
    #   advance_state
    # end

    # def failure
    # end

    # private
    # def correct_order_state
    #   (@order.state == 'payment' || @order.state == 'complete') &&
    #     @order.payments.last.payment_method && @order.payments.m_method &&
    #     (@order.payments.last.payment_method.type == "PaymentMethod::MercadoPago")
    # end

    # def advance_state
    #   @order.update_attributes( { :state => "complete", :completed_at => Time.now },
    #                            :without_protection => true)
    # end

    # def get_order
    #   user = spree_current_user
    #   order_no = params[:order_number]
    #   @order = Order.where(number: order_no).where(user_id: user.id).first

    #   unless @order && correct_order_state
    #     if @order.present?
    #       redirect_to checkout_state_path(@order.state)
    #     else
    #       flash[:error] = I18n.t(:mp_invalid_order)
    #       redirect_to root_path
    #     end
    #     return
    #   end
    # end
  end
end
