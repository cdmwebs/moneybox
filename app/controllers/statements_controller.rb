class StatementsController < ApplicationController

  def index
    @statements = Statement.all
  end

  def new
    @statement = Statement.new
  end

  def show
    @statement = Statement.find params[:id]
  end

  def create
    @statement = Statement.create(params[:statement])
    if @statement.valid?
      flash[:success] = "Statement Created"
      redirect_to statement_path(@statement)
    else
      flash[:error] = "Please see errors, below"
      render 'new'
    end

  end

  def add_transaction
    statement = Statement.find(params[:statement][:id])
    transaction = Transaction.find(params[:statement][:transaction_id])
    statement.transactions << transaction
    statement.save
    transaction.clear
    transaction.save
    redirect_to :back
  end

  def remove_transaction
    statement = Statement.find(params[:statement][:id])
    transaction = Transaction.find(params[:statement][:transaction_id])
    statement.transactions.reject! { |t| t == transaction }
    statement.save
    transaction.open
    transaction.save
    redirect_to :back
  end


end
