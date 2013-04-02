class Statement < ActiveRecord::Base

  # ------------------------------------------- Associations

  has_many :transactions
  belongs_to :account

  # ------------------------------------------- Accessors

  attr_accessible :end_balance, :end_date, :start_balance, :start_date, :account, :reconciled, :account_id

  # ------------------------------------------- Callbacks

  after_update :check_reconciled

  # ------------------------------------------- Plugins

  monetize :start_balance_cents
  monetize :end_balance_cents
  has_attached_file :attachment

 # ------------------------------------------- Instance Methods

  def possible_transactions
    first_date = (start_date - 3.days).to_date
    last_date = (end_date + 3.days).to_date
    transactions.unscoped.where('account_id = ?', account.id).where('entry_date >= ? AND entry_date <= ?', first_date, last_date).order('entry_date ASC')
  end

  def transaction_total
    transactions.collect{|t| t.amount.to_f}.reduce(0,:+).to_money
  end

  def unreconciled_amount
    end_balance - start_balance - transaction_total
  end

  def reconciled?
    unreconciled_amount == 0
  end

  def check_reconciled
    self.update_column :reconciled, self.reconciled? ? true : false
  end

end
