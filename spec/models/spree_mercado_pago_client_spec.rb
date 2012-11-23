# -*- encoding : utf-8 -*-
require 'spec_helper'

describe SpreeMercadoPagoClient do
  let(:payment_method) do
    double(
      "payment_method",
      :preferred_client_id => 1,
      :preferred_client_secret => 1
    )
  end

  let(:order) { double("order", :payment_method => payment_method, :number => "testorder", :line_items => []) }
  let(:url_callbacks) { {success: "url", failure: "url", pending: "url"} }

  describe "#initialize" do
    it "raises error if initialized without callbacks" do
      expect {
        SpreeMercadoPagoClient.new(order, {})
      }.to raise_error
    end

    it "doesn't raise error with all callbacks" do
      expect {
        SpreeMercadoPagoClient.new(order, url_callbacks)
      }.not_to raise_error
    end
  end

  describe "#authenticate" do
    let(:client) { SpreeMercadoPagoClient.new(order, url_callbacks) }

    it "should return truthy value" do
      response = double("response")
      response.stub(:code) { 200 }
      response.stub(:to_str) { {access_token: "123"}.to_json }
      RestClient.should_receive(:post) { response }

      client.authenticate.should be_true
    end

    it "raises exception on invalid authentication" do
      response = double("response")
      response.stub(:code) { 400 }
      response.stub(:to_str) { {}.to_json }
      RestClient.should_receive(:post) { response }

      expect { client.authenticate }.to raise_error
    end
  end

  describe "#send_data" do
    it "should return truthy value on success"
  end

  describe "#redirect_url" do
    it "should return offsite checkout url" 
  end
end
