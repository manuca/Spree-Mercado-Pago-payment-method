# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Spree::MercadoPagoController do
  it "finds the order asociated with the current user"
  it "handles case where user is logged out"
  # it "doesn't affect current order if there is one (session[:order_id])"
  
  describe "#success" do
    it "marks the order as complete"
    it "shows success message"
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
