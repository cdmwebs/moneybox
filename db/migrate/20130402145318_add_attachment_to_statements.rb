class AddAttachmentToStatements < ActiveRecord::Migration

  def up
    add_attachment :statements, :attachment
  end

  def down
    add_attachment :statements, :attachment
  end

end
