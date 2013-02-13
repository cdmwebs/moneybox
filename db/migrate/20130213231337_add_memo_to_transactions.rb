class AddMemoToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :memo, :string
  end
end
