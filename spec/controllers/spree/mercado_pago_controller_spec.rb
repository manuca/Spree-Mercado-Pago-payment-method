# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Spree::MercadoPagoController do
  it "doesn't affect current order if there is one (session[:order_id])"

  context "Logged out user" do
    it "redirects to login and back again"
  end

  context "Logged in user" do
    let(:user)           { create(:user) }
    let(:payment_method) { create(:payment_method, type: "PaymentMethod::MercadoPago") }
    let(:order)          do
      order = create(:order, user: user, state: "payment")
      create(:payment, payment_method: payment_method, order: order)
      order
    end

    before { controller.stub(:spree_current_user => user) }
    before do
      order.payment.should_not be_nil
      order.payment_method.should_not be_nil
      order.payment_method.type.should eq("PaymentMethod::MercadoPago")
    end

    describe "#success" do
      before do
        spree_get :success, { order_number: order.number }
      end

      it { response.should be_success }
      it { assigns(:order).should_not be_nil }
      it { assigns(:order).state.should eq("complete") }
      it { assigns(:order).id.should eq(order.id)}
      it { assigns(:order).payment.state.should eq("pending") }
    end

    describe "#pending" do
      before do
        spree_get :pending, { order_number: order.number }
      end

      it { response.should be_success }
      it { assigns(:order).should_not be_nil }
      it { assigns(:order).state.should eq("complete") }
      it { assigns(:order).id.should eq(order.id)}
      it { assigns(:order).payment.state.should eq("pending") }
    end

    describe "#failure" do
      before do
        spree_get :failure, { order_number: order.number }
      end

      it { response.should be_success }
      it { assigns(:order).should_not be_nil }
      it { assigns(:order).state.should eq("payment") }
      it { assigns(:order).id.should eq(order.id)}
      it { assigns(:order).payment.state.should eq("pending") }
    end
  end
end
