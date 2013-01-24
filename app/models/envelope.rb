class Envelope < ActiveRecord::Base

  # ------------------------------------------- Associations

  has_many :transactions

  # ------------------------------------------- Plugins

  monetize :balance_cents

  # ------------------------------------------- Accessors

  attr_accessible :name, :balance

  ###---------------------------------------------------- Attributes

  alias_attribute :to_s, :name

  ###---------------------------------------------------- Validations

  validates_presence_of :name


  ###---------------------------------------------------- Instance Methods

  def badge_style
    balance.to_f < 0 ? 'badge-important' : 'badge-success'
  end

end
