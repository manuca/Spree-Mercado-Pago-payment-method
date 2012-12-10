# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Spree::MercadoPagoController do
  it "finds the order asociated with the current user"
  it "handles case where user is logged out"
  it "doesn't affect current order if there is one (session[:order_id])"
  
  describe "#success" do
    let(:user)  { double("User", :last_incomplete_spree_order => nil) }
    let(:order) { FactoryGirl.create(:order) }

    before { controller.stub(:spree_current_user => user) }

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
