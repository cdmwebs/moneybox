class RemoveDefaultFromEntryDate < ActiveRecord::Migration

  def up
    change_column_default :transactions, :entry_date, nil
    change_column_default :transactions, :amount_cents, nil
  end

end
