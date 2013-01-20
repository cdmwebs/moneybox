class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.money :balance, default: 0, null: false
      t.timestamps
    end
  end
end
