class AddEntryDateToTransactions < ActiveRecord::Migration

  def change
    add_column :transactions, :entry_date, :date, null: false, default: Time.now 
  end

end
