describe "OrderPreferencesBuilder" do
  
  let(:order) { create :order_with_line_items } 
  let(:payment) { create :payment }
  let(:callback_urls) { {success:"http://example.com/success", pending:"http://example.com/pending", failure: "http://example.com/failure" }}
  let(:payer_data) { {email:"jmperez@devartis.com"}}

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
          title: line_item_description_text(line_item.variant.product.description),
          unit_price: line_item.price.to_f,
          quantity: line_item.quantity,
          currency_id: "ARS"
        })
      end
    end

    it "should set an item for shipment cost" do
      expect(subject[:items]).to include({
        title: "Costo de envío",
        unit_price: order.ship_total.to_f,
        quantity: 1,
        currency_id: "ARS"
      })
    end
  end
end