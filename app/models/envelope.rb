class Envelope < ActiveRecord::Base

  # ------------------------------------------- Associations

  has_many :transactions

  # ------------------------------------------- Plugins

  monetize :balance_cents

  # ------------------------------------------- Accessors

  attr_accessible :name, :balance

  ###---------------------------------------------------- Attributes

  alias_attribute :to_s, :name

  ###---------------------------------------------------- Instance Methods

end
