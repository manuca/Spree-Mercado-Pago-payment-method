require 'spec_helper'

describe "OrderPreferencesBuilder" do
  # Factory order_with_line_items is incredibly slow..
  let(:order) do
    order = create(:order)
    create_list(:line_item, 2, order: order)
    order.line_items.reload
    order.update!
    order
  end

  let(:payment)       { create(:payment) }
  let(:callback_urls) { {success: "http://example.com/success", pending: "http://example.com/pending", failure: "http://example.com/failure"} }
  let(:payer_data)    { {email:"jmperez@devartis.com"} }

  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::SanitizeHelper
  include Spree::ProductsHelper

  context "Calling preferences_hash" do
    subject { MercadoPago::OrderPreferencesBuilder.new(order, payment, callback_urls, payer_data).preferences_hash }

    it "should return external reference" do
      expect(subject).to include(external_reference:payment.identifier)
    end

    it "should set callback urls" do
      expect(subject).to include(back_urls:callback_urls)
    end

    it "should set payer data if brought" do
      expect(subject).to include(payer: payer_data)
    end

    it "should set an item for every line item" do
      expect(subject).to include(:items)

      order.line_items.each do |line_item|
        expect(subject[:items]).to include({
          title: line_item_description_text(line_item.variant.product.name),
          unit_price: line_item.price.to_f,
          quantity: line_item.quantity.to_f,
          currency_id: "ARS"
        })
      end
    end

    context "for order with adjustments" do
      let!(:adjustment) { Spree::Adjustment.create!(adjustable: order, order: order, label: "Descuento", amount: -10.0) }

      it "should set its adjustments as items" do
        expect(subject[:items]).to include({
          title: line_item_description_text(adjustment.label),
          unit_price: adjustment.amount.to_f,
          quantity: 1,
          currency_id: "ARS"
        })
      end

      it "should only have line items and adjustments in items" do
        expect(subject[:items]).to have(order.line_items.count + order.adjustments.count).items
      end
    end
  end
end
