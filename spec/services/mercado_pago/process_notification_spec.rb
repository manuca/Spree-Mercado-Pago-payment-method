require 'spec_helper'

module MercadoPago
  describe ProcessNotification do
    let(:order)   { FactoryGirl.create(:completed_order_with_pending_payment) }
    let(:payment) { order.payments.first }

    let(:operation_id) { "op123" }
    let(:notification) { Notification.new(topic: "payment", operation_id: operation_id) }
    let(:operation_info) do
      {
        "collection" => {
          "external_reference" => order.payments.first.identifier,
          "status" => "approved"
        }
      }
    end

    before do
      fake_client = double("fake_client")
      Spree::PaymentMethod::MercadoPago.stub(provider: fake_client)
      fake_client.should_receive(:get_operation_info).with(operation_id).
        and_return(operation_info)
      payment.pend!
      payment.state.should eq("pending")
    end

    describe "#process!" do
      it "completes payment for approved payment" do
        ProcessNotification.new(notification).process!
        payment.reload
        payment.state.should eq("completed")
      end

      it "fails payment for rejected payment" do
        operation_info["collection"]["status"] = "rejected"
        ProcessNotification.new(notification).process!
        payment.reload
        payment.state.should eq("failed")
      end

      it "voids payment for rejected payment" do
        operation_info["collection"]["status"] = "cancelled"
        ProcessNotification.new(notification).process!
        payment.reload
        payment.state.should eq("void")
      end

      it "pends payment for pending payment" do
        operation_info["collection"]["status"] = "pending"
        ProcessNotification.new(notification).process!
        payment.reload
        payment.state.should eq("pending")
      end
    end
  end
end
