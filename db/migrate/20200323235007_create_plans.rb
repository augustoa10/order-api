class CreatePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.decimal :yearly_price, null: false

      t.timestamps
    end
  end
end
