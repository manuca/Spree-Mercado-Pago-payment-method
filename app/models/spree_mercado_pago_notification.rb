module Spree
  module MercadoPago
    class Notification < ActiveRecord::Base
      self.table_name = "spree_mercado_pago_notification"
    end
  end
end
