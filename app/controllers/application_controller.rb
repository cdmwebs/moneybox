class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private

    helper_method :current_transactions, :set_collections

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

    def set_collections
      @transactions = current_transactions
      @envelopes = Envelope.all
      @accounts = Account.all
    end

end
