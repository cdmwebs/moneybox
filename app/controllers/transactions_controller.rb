class TransactionsController < ApplicationController

  before_filter :set_collections

  def index
    @transactions = current_transactions
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.create params[:transaction]
    if @transaction.valid?
      flash[:success] = "&ldquo;#{@transaction.payee}&rdquo; transaction created"
      redirect_to root_path
    else
      flash[:error] = "Please see errors, below"
      render 'new'
    end
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

  protected

    helper_method :set_collections

    def set_collections
      @envelopes = Envelope.all
      @accounts = Account.all
    end


end
