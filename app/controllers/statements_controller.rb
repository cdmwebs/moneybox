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

  def edit
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

  def add_or_remove_transaction
    @statement = Statement.find(params[:statement_id])
    transaction = Transaction.find(params[:transaction_id])
    if @statement.transactions.include? transaction
      updated_transactions = @statement.transactions.reject { |t| t == transaction }
      @statement.transactions = updated_transactions
      transaction.open
    else
      @statement.transactions << transaction
      transaction.clear
    end
    @statement.save
    if request.xhr?
      render partial: 'statements/transaction', locals: {transaction: transaction}
    else
      redirect_to :back
    end
  end

  def totals
    @statement = Statement.find(params[:statement_id])
    render partial: 'totals'
  end

end
