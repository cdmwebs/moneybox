class ApplicationController < ActionController::Base

  protect_from_forgery

  layout :layout_by_resource

  before_filter :authenticate_user!
  before_filter :set_collections, except: [:transfer]

  private

    helper_method :current_transactions, :set_collections

    def current_transactions
      @current_transactions ||= begin
        if params[:envelope_id].present? || params[:controller] == 'envelopes' && params[:id].present?
          lookup_param = params[:envelope_id].present? ? params[:envelope_id] : params[:id]
          Envelope.find(lookup_param).transactions.order('entry_date DESC').page(params[:page])
        elsif params[:account_id].present? || params[:controller] == 'accounts' && params[:id].present?
          lookup_param = params[:account_id].present? ? params[:account_id] : params[:id]
          Account.find(lookup_param).transactions.order('entry_date DESC').page(params[:page])
        else
          Transaction.accounted.order('entry_date DESC').page(params[:page])
        end
      end
    end

    def set_collections
      @transactions ||= current_transactions
      @envelopes ||= Envelope.ordered
      @accounts ||= Account.ordered
    end

    def layout_by_resource
      if devise_controller?
        'session'
      else
        'application'
      end
    end


end
