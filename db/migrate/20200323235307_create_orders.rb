class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :device_model, null: false
      t.string :device_imei, null: false, unique: true
      t.integer :installments, null: false

      t.references :user, foreign_key: true
      t.references :plan, foreign_key: true

      t.index [:user_id, :plan_id, :device_imei]

      t.timestamps
    end
  end
end
