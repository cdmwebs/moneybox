class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private

    helper_method :current_transactions, :set_collections

    def current_transactions
      @current_transactions ||= begin
        if params[:envelope_id].present? || params[:controller] == 'envelopes' && params[:id].present?
          lookup_param = params[:envelope_id].present? ? params[:envelope_id] : params[:id]
          Envelope.find(lookup_param).transactions.order('entry_date DESC')
        elsif params[:account_id].present? || params[:controller] == 'accounts' && params[:id].present?
          lookup_param = params[:account_id].present? ? params[:account_id] : params[:id]
          Account.find(lookup_param).transactions.order('entry_date DESC')
        else
          Transaction.order('entry_date DESC')
        end
      end
    end

    def set_collections
      @transactions = current_transactions
      @envelopes = Envelope.all
      @accounts = Account.all
    end

end
