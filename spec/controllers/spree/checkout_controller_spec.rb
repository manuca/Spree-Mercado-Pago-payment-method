require 'spec_helper'

describe Spree::CheckoutController do
  # let(:order) do
  #   mock_model(Spree::Order, :checkout_allowed? => true,
  #              :user => nil,
  #              :email => nil,
  #              :completed? => false,
  #              :update_attributes => true,
  #              :payment? => false,
  #              :insufficient_stock_lines => [],
  #              :coupon_code => nil).as_null_object
  # end

  context "Using Mercado Pago payment method" do
    before(:each) do
      user = double("User", :last_incomplete_spree_order => nil)
      controller.stub(:spree_current_user => user)

      payment_method = double("PaymentMethod::MercadoPago")
      payment_method.should_receive(:kind_of?).with(PaymentMethod::MercadoPago) { true }
      Spree::PaymentMethod.should_receive(:find) { payment_method }
    end

    it "redirects to m.redirect_url on success" do
      client = double("client")
      client.should_receive(:authenticate) { true }
      client.should_receive(:send_data) { true }
      client.should_receive(:redirect_url) { "http://www.example.com" }
      SpreeMercadoPagoClient.should_receive(:new) { client }

      spree_post :update, {:state => "payment"}
      response.should redirect_to(client.redirect_url)
    end

    it "renders mercado_pago_error.html.erb on error" do
      client = double("client")
      client.should_receive(:authenticate) { false }
      client.should_receive(:send_data) { true }
      client.should_receive(:redirect_url) { "http://www.example.com" }
      SpreeMercadoPagoClient.should_receive(:new) { client }

      spree_post :update, {:state => "payment"}
      response.should render_template("mercado_pago_error")
    end
  end
end
