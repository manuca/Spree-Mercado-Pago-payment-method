class CreateSpreeMercadoPagoNotifications < ActiveRecord::Migration
  def change
    create_table :spree_mercado_pago_notifications do |t|
      t.string :notification_id
      t.string :topic

      t.timestamps
    end
  end
end
