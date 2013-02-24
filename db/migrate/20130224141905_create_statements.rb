class CreateStatements < ActiveRecord::Migration

  def up
    create_table :statements do |t|
      t.date :start_date
      t.date :end_date
      t.integer :start_balance_cents
      t.integer :end_balance_cents
      t.references :account
      t.boolean :reconciled, default: false
      t.timestamps
    end

    add_column :transactions, :statement_id, :integer
  end

  def down
    drop_table :statements
    remove_column :transactions, :statement_id
  end

end
