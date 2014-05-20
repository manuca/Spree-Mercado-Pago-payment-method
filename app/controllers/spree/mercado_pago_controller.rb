# -*- encoding : utf-8 -*-
module Spree

  class MercadoPagoController < Spree::StoreController

    before_filter :verify_external_reference, :current_payment, only: [:success, :pending]
    before_filter :payment_method_by_external_reference, :only => [:success, :pending, :failure]
    before_filter :verify_payment_state, :only => [:payment]
    skip_before_filter :verify_authenticity_token, :only => [:notification]

    # If the order is in 'payment' state, redirects to Mercado Pago Checkout page
    def payment
      mp_payment = current_order.payments.create! source: payment_method,
        amount: current_order.total,
        payment_method: @payment_method

      if create_preferences(mp_payment)
        redirect_to provider.redirect_url
      else
        render 'spree/checkout/mercado_pago_error'
      end
    end

    def pending
      advance_state
    end

    def failure
    end

    private

    def create_preferences(mp_payment)
      preferences = create_preference_options(current_order, mp_payment, back_urls)
      provider.create_preferences(preferences)
    end

    def create_preference_options(order, payment, callbacks)
      builder = MercadoPago::OrderPreferencesBuilder.new order, payment, callbacks, payer_data

      return builder.preferences_hash
    end


    def render_result(current_state)
      process_payment current_payment
      if success_order? and current_state != :success
        redirect_to_state :success
      end
      if failed_payment? and current_state != :failure
        redirect_to_state :failure
      end
      if pending_payment? and current_state != :pending
        redirect_to_state :pending
      end

    end

    def payment_method
      @payment_method ||= ::PaymentMethod::MercadoPago.find (params[:payment_method_id])
    end

    def provider
      @provider ||= payment_method.provider({:payer => payer_data})
    end

    def advance_state
      @order.update_attributes( { :state => "complete", :completed_at => Time.now },
                               :without_protection => true)
    end

    def get_order
      user = spree_current_user
      order_no = params[:order_number]
      @order = Order.where(number: order_no).where(user_id: user.id).first

      unless @order && correct_order_state
        if @order.present?
          redirect_to checkout_state_path(@order.state)
        else
          flash[:error] = I18n.t(:mp_invalid_order)
          redirect_to root_path
        end
        return
      end
    end
  end
end
