class CreateEnvelopes < ActiveRecord::Migration
  def change
    create_table :envelopes do |t|
      t.string :name
      t.money :balance, default: 0, null: false
      t.timestamps
    end
  end
end
