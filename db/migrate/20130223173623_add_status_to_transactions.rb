class AddStatusToTransactions < ActiveRecord::Migration
  
  def up
    add_column :transactions, :status, :string, default: 'open'
  end

  def down
    remove_column :transactions, :status
  end

end
