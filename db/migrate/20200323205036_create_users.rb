class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :cpf, limit: 11, null: false, unique: true, index: true
      t.string :email, null: false

      t.index :email, unique: true

      t.timestamps
    end
  end
end
