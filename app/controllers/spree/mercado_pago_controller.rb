# -*- encoding : utf-8 -*-
require 'rest_client'

module Spree
  class MercadoPagoController < Spree::BaseController
    before_filter :get_order

    def success
      advance_state
    end

    def pending
      advance_state
    end

    def failure
    end

    private
    def correct_order_state
      (@order.state == 'payment' || @order.state == 'complete') &&
        @order.payments.last.payment_method && @order.payments.m_method &&
        (@order.payments.last.payment_method.type == "PaymentMethod::MercadoPago")
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
