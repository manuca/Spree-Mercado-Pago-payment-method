module MercadoPago
  class OrderPreferencesBuilder
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::SanitizeHelper
    include Spree::ProductsHelper

    def initialize(order, payment, callback_urls, payer_data=nil)
      @order = order
      @payment = payment
      @callback_urls = callback_urls
      @payer_data = payer_data
    end

    def preferences_hash
      {
        external_reference: @payment.identifier,
        back_urls: @callback_urls,
        payer: @payer_data,
        items: generate_items
      }
    end


  private

    def generate_items
      items = []

      items += generate_items_from_line_items
      items += generate_items_from_adjustments

      items
    end

    def generate_items_from_line_items
      @order.line_items.collect do |line_item|
        {
          :title => line_item_description_text(line_item.variant.product.description),
          :unit_price => line_item.price.to_f,
          :quantity => line_item.quantity,
          :currency_id => 'ARS'
        }
      end
    end

    def generate_items_from_adjustments
      @order.adjustments.collect do |adjustment|
        {
          title: adjustment.label,
          unit_price: adjustment.amount.to_f,
          quantity: 1,
          currency_id: "ARS"
        }
      end
    end
  end
end
