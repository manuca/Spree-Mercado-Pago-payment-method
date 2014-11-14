module Spree
  class MercadoPagoController < StoreController
    # Order must be in payment state
    # Find payment method
    # Send preferences to MP
    # Create Payment for this order with found payment method
    # payment.started_processing
    # Redirect to MP init point
    def checkout
      current_order || raise(ActiveRecord::RecordNotFound)
      payment_method = PaymentMethod::MercadoPago.find(params[:payment_method_id])
      payment = current_order.payments.create!({amount: current_order.total, payment_method: payment_method})
      payment.started_processing!
      render text: current_order.number
    end

    def success
      # Pass payment to pending state
      # Flash success with pending order
      # Redirect to order list
    end

    def pending
      # Pass payment to pending state
      # Flash success with pending order
      # Redirect to order list
    end

    def failure
      # Pass payment to failed state
      # Flash error
      # Redirect to checkout state payment
    end

    def ipn
      # Search for payment by external reference
      # Fetch payment status from MP
      # Update payment status to complete if payed and assign payment info as payment source
      # payment.complete!
      # Notify user
    end

    private

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
