require 'spec_helper'

describe Spree::CheckoutController do
  let(:order) do
    mock_model(Spree::Order, :checkout_allowed? => true,
               :user => nil,
               :email => nil,
               :completed? => false,
               :update_attributes => true,
               :payment? => false,
               :insufficient_stock_lines => [],
               :coupon_code => nil).as_null_object
  end

  context "Using Mercado Pago payment method" do
    # before(:each) do
    #   payment_method = double("PaymentMethod::MercadoPago")
    #   Spree::PaymentMethod.stub(:find) { payment_method }
    #   payment_method.should_receive(:kind_of?) { true }
    # end

    it "assigns @payment_method of kind PaymentMethod::MercadoPago" do
      pending

      user = double("User", :last_incomplete_spree_order => nil)
      controller.stub(:spree_current_user => user)
      spree_post :update, {:state => "payment"}
    end

    it "invokes #send_data"
    it "redirects to m.redirect_url on success"
    it "renders mercado_pago_error.html.erb on error"
  end
end
