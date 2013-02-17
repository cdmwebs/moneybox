class AddRunningBalancesToTransactions < ActiveRecord::Migration

  def change

    add_column :transactions, :current_account_balance_cents, :integer, default: 0
    add_column :transactions, :current_envelope_balance_cents, :integer, default: 0

  end

end
