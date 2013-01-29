class TransactionsController < ApplicationController

  before_filter :set_collections

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

end
