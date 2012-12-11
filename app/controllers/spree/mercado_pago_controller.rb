# -*- encoding : utf-8 -*-
require 'rest_client'

module Spree
  class MercadoPagoController < Spree::BaseController
    before_filter :get_order

    def success
    end

    def pending
    end

    def failure
    end

    private
    def correct_order_state
      (@order.state == 'payment' || @order.state == 'complete') && 
        @order.payment_method && 
        (@order.payment_method.type == "PaymentMethod::MercadoPago")
    end

    def get_order
      user = spree_current_user
      order_no = params[:order_number]
      @order = Order.where(number: order_no).where(user_id: user.id).first

      unless @order && correct_order_state
        if @order.present?
          redirect_to checkout_state_path(@order.state)
        else
          redirect_to root_path
        end
        return
      end

      # @order.update_attribute(:state, "complete")
      while @order.state != "complete"
        @order.next
      end
    end
  end
end
