class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.references :booking, null: false, foreign_key: true
      t.string :payment_method
      t.decimal :amount
      t.datetime :payment_date
      t.string :status

      t.timestamps
    end
  end
end
