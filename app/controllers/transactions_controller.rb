class TransactionsController < ApplicationController

  before_filter :check_polarity, only: [:update, :create]

  def new
    @transaction = Transaction.new
  end

  def edit
    @transaction = Transaction.find params[:id]
  end


  def update
    @transaction = Transaction.find params[:id]
    @transaction.update_attributes params[:transaction]
    if @transaction.valid?
      flash[:success] = "&ldquo;#{@transaction.payee}&rdquo; transaction updated"
      redirect_to transactions_path
    else
      flash[:error] = "Please see errors, below"
      render 'edit'
    end
  end

  def create
    @transaction = Transaction.create params[:transaction]
    if @transaction.valid?
      flash[:success] = "&ldquo;#{@transaction.payee}&rdquo; transaction created"
      redirect_to transactions_path
    else
      flash[:error] = "Please see errors, below"
      render 'new'
    end
  end

  private

    def check_polarity
      amount = params[:transaction][:amount].to_f 
      params[:transaction][:amount] = params[:withdrawal] == 'y' ? 0 - amount.abs : amount.abs
    end

end
