class Statement < ActiveRecord::Base

  # ------------------------------------------- Associations

  has_many :transactions
  belongs_to :account

  # ------------------------------------------- Accessors

  attr_accessible :end_balance, :end_date, :start_balance, :start_date, :account, :reconciled

  # ------------------------------------------- Plugins

  monetize :start_balance_cents
  monetize :end_balance_cents

 # ------------------------------------------- Instance Methods

  def reconciled?
    reconciled == true
  end

end
