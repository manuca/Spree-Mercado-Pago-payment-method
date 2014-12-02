require 'spec_helper'

module Spree
  describe MercadoPagoController do
    describe "#ipn" do
      let(:operation_id) { "op123" }

      describe "for valid notifications" do
        let(:use_case) { double("use_case") }

        it "handles notification and returns success" do
          MercadoPago::HandleReceivedNotification.should_receive(:new).and_return(use_case)
          use_case.should_receive(:process!)

          spree_post :ipn, { id: operation_id, topic: "payment" }
          response.should be_success

          notification = ::MercadoPago::Notification.order(:created_at).last
          notification.topic.should eq("payment")
          notification.operation_id.should eq(operation_id)
        end
      end

      describe "for invalid notification" do
        it "responds with invalid request" do
          spree_post :ipn, { id: operation_id, topic: "nonexistent_topic" }
          response.should be_bad_request
        end
      end
    end
  end
end
