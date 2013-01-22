class TransactionsController < ApplicationController

  def index
    @transactions = Transaction.all
    @envelopes = Envelope.all
    @accounts = Account.all
    logger.debug @transactions.inspect
  end

end
