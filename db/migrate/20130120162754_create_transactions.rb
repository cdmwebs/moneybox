class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :payee
      t.money :amount, default: 0, null: false
      t.references :account
      t.references :envelope
      t.timestamps
    end
  end
end
