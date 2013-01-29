class Transaction < ActiveRecord::Base

  # ------------------------------------------- Callbacks

  after_save :update_balances
  before_destroy :rollback_balances

  # ------------------------------------------- Associations

  belongs_to :account
  belongs_to :envelope

  # ------------------------------------------- Plugins

  monetize :amount_cents

  # ------------------------------------------- Accessors

  attr_accessible :amount, :payee, :account, :envelope, :account_id, :envelope_id, :created_at

  # ------------------------------------------- Validations

  validates :payee, presence: true
  validates :amount, numericality: true, exclusion: { in: [0] }

  # ------------------------------------------- Instance Methods
  protected

    def rollback_balances
      update_balances('down')
    end

    def update_balances(direction='up')
      modifier = direction == 'down' ? -self.amount : self.amount
      [self.account, self.envelope].each do |object|
        object.balance += modifier
        object.save
      end
    end


end
