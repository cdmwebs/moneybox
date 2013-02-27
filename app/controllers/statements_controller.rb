class StatementsController < ApplicationController

  def new
    @statement = Statement.new
  end

  def create
    @statement = Statement.create(params[:statement])
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
