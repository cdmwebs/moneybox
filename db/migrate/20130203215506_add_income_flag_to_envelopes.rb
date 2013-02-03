class AddIncomeFlagToEnvelopes < ActiveRecord::Migration

  def change
    add_column :envelopes, :income, :boolean, default: false
  end

end
