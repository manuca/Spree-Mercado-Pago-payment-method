require 'spec_helper'

module MercadoPago
  describe Notification do
    describe "without basic parameters" do
      it { Notification.new.should_not be_valid }
    end

    describe "with unknown topic" do
      it { Notification.new(topic: "foo", operation_id: "op123").should_not be_valid }
    end

    describe "with correct parameters" do
      it { Notification.new(topic: "payment", operation_id: "op123").should be_valid }
    end
  end
end
