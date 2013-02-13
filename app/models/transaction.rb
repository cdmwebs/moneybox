class Transaction < ActiveRecord::Base

  # ------------------------------------------- Callbacks

  after_initialize :set_entry_date
  after_create :update_balances
  before_update :subtract_old_balances
  after_update :update_balances
  before_destroy :rollback_balances

  # ------------------------------------------- Associations

  belongs_to :account
  belongs_to :envelope

  # ------------------------------------------- Accessors

  attr_accessible :amount, :payee, :account, :envelope, :account_id, :envelope_id, :entry_date, :attachment, :memo

  # ------------------------------------------- Plugins

  monetize :amount_cents
  has_attached_file :attachment

  # ------------------------------------------- Validations

  validates :payee, presence: true
  validates :amount, numericality: true, exclusion: { in: [0] }
  validates_attachment :attachment, :content_type => { content_type: "application/pdf" }

  # ------------------------------------------- Scopes

  scope :deposits, where('amount_cents > 0')
  scope :withdrawals, where('amount_cents < 0')

  # ------------------------------------------- Class Methods
  protected

    def rollback_balances
      update_balances('down')
    end

    def update_balances(direction='up')
      modifier = direction == 'down' ? -self.amount : self.amount
      [self.account, self.envelope].each do |object|
        if object.present?
          object.balance += modifier
          object.save
        end
      end
    end

    def subtract_old_balances
      affected_account = account_id_was != account_id ? Account.find(account_id_was) : account
      affected_envelope = envelope_id_was != envelope_id ? Envelope.find(envelope_id_was) : envelope
      adjustment_amount = amount_cents_was != amount_cents ? amount_cents_was : amount_cents
      [affected_account, affected_envelope].each do |object|
        object.balance_cents -= adjustment_amount
        object.save
      end
    end

    self.per_page = 20

    def set_entry_date
      self.entry_date ||= Date.today if new_record?
    end


end
