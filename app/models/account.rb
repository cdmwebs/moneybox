class Account < ActiveRecord::Base

  # ------------------------------------------- Associations

  has_many :transactions, dependent: :restrict

  # ------------------------------------------- Plugins

  monetize :balance_cents

  # ------------------------------------------- Accessors

  attr_accessible :name, :balance

  ###---------------------------------------------------- Attributes

  alias_attribute :to_s, :name
  alias_attribute :title, :name

  ###---------------------------------------------------- Validations

  validates :name, presence: true, uniqueness: true
  validates :balance, numericality: true

  ###---------------------------------------------------- Scopes

  scope :empty, where('balance_cents = 0')
  scope :positive, where('balance_cents > 0')
  scope :negative, where('balance_cents < 0')

  ###---------------------------------------------------- Instance Methods

  def badge_style
    balance.to_f < 0 ? 'badge-important' : 'badge-success'
  end

  def balance?
    balance != 0
  end

  ###---------------------------------------------------- Class Methods
  private

    def self.ordered
      [self.negative, self.positive, self.empty].flatten
    end

end
