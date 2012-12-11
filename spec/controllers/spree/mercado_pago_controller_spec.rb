# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Spree::MercadoPagoController do
  it "finds the order asociated with the current user"
  it "handles case where user is logged out redirects to login and back again"
  it "doesn't affect current order if there is one (session[:order_id])"
  
  describe "#success" do
    let(:user)           { create(:user) }
    let(:payment_method) { create(:payment_method, type: "PaymentMethod::MercadoPago") }
    let(:payment)        { create(:payment, payment_method: payment_method) }
    let(:order)          { create(:order, user: user, state: "payment", payment: payment) }

    before { controller.stub(:spree_current_user => user) }

    it "returns success" do
      spree_get :success, { order_number: order.number }
      response.should be_success
    end

    it "marks the order as complete" do
      spree_get :success, { order_number: order.number }
      assigns(:order).should_not be_nil
      assigns(:order).state.should eq("complete")
    end
  end

  describe "#pending" do
    it "marks order as complete"
    it "shows pending payment message"
  end

  describe "#failure" do
    it "leaves order in payment state"
    it "shows failure (or cancelled) message"
  end
end
