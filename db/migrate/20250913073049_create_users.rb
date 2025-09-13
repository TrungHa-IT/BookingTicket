class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :fullname
      t.string :email
      t.string :phone
      t.string :password_hash
      t.integer :role

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :phone, unique: true
  end
end
