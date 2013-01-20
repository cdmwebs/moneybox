class TransactionsController < ApplicationController

  def index
    @transactions = Transaction.all
    logger.debug @transactions.inspect
  end

end
