class TransactionsController < ApplicationController

  def index
    @transactions = current_transactions
    @envelopes = Envelope.all
    @accounts = Account.all
    logger.debug @transactions.inspect
  end

  private

    helper_method :current_transactions

    def current_transactions
      @current_transactions ||= begin
        if params[:envelope_id].present?
          Envelope.find(params[:envelope_id]).transactions
        elsif params[:account_id].present?
          Account.find(params[:account_id]).transactions
        else
          Transaction.all
        end
      end
    end


end
