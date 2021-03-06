class Envelope < ActiveRecord::Base

  # ------------------------------------------- Associations

  has_many :transactions, dependent: :restrict

  # ------------------------------------------- Plugins

  monetize :balance_cents

  # ------------------------------------------- Accessors

  attr_accessible :name, :balance, :income

  ###---------------------------------------------------- Attributes

  alias_attribute :to_s, :name_and_balance

  ###---------------------------------------------------- Validations

  validates :name, presence: true, uniqueness: true
  validates :balance, numericality: true

  ###---------------------------------------------------- Scopes

  scope :income, where('income = ?', true)
  scope :empty, where('balance_cents = 0 and income = ?', false)
  scope :positive, where('balance_cents > 0 and income = ?', false)
  scope :negative, where('balance_cents < 0 and income = ?', false)

  ###---------------------------------------------------- Instance Methods

  def badge_style
    balance.to_f < 0 ? 'badge-important' : balance.to_f > 0 ? 'badge-success' : ''
  end

  def row_style
    balance.to_f < 0 ? 'negative' : balance.to_f > 0 ? 'positive' : ''
  end

  def balance?
    balance != 0
  end

  def name_and_balance
    "#{name} (#{balance.format})"
  end

  ###---------------------------------------------------- Class Methods
  private
  
  def self.ordered
    [self.income, self.negative, self.positive, self.empty].flatten
  end

  def self.expense
    [self.negative, self.positive, self.empty].flatten
  end

  def self.transfer(from, to, value)
    transfer_amount = value.to_f
    Transaction.create payee: "Transfer to #{to.name}", envelope: from, amount: -transfer_amount
    Transaction.create payee: "Transfer from #{from.name}", envelope: to, amount: transfer_amount
  end

end
