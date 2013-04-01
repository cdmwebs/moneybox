class Statement < ActiveRecord::Base

  # ------------------------------------------- Associations

  has_many :transactions
  belongs_to :account

  # ------------------------------------------- Accessors

  attr_accessible :end_balance, :end_date, :start_balance, :start_date, :account, :reconciled, :account_id

  # ------------------------------------------- Plugins

  monetize :start_balance_cents
  monetize :end_balance_cents

 # ------------------------------------------- Instance Methods

  def possible_transactions
    first_date = (start_date - 3.days).to_date
    last_date = (end_date + 3.days).to_date
    transactions.unscoped.where('account_id = ?', account.id).where('entry_date >= ? AND entry_date <= ?', first_date, last_date).order('entry_date ASC')
  end

  def balance_difference
      end_balance - start_balance
  end

  def transaction_total
    transactions.collect{|t| t.amount.to_f}.reduce(0,:+).to_money
  end

  def difference
    balance_difference - transaction_total
  end

  def reconciled?
    difference == 0
  end

end
