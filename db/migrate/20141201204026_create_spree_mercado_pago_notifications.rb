class CreateSpreeMercadoPagoNotifications < ActiveRecord::Migration
  def change
    create_table :mercado_pago_notifications do |t|
      t.string :topic
      t.string :operation_id
      t.timestamps
    end
  end
end
