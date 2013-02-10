class AddAttachmentToTransactions < ActiveRecord::Migration

  def up
    add_attachment :transactions, :attachment
  end

  def down
    add_attachment :transactions, :attachment
  end

end
