class AccountsController < ApplicationController

  before_filter :set_collections

  def index
    @accounts = Account.all
  end

  def new
    @envelope = Account.new
  end

  protected

    helper_method :set_collections

    def set_collections
      @envelopes = Envelope.all
      @accounts = Account.all
    end

end
