class AccountsController < ApplicationController

  def index
    @accounts = Account.ordered
  end

  def new
    @account = Account.new
  end

  def edit
    @account = Account.find params[:id]
  end

  def update
    @account = Account.find params[:id]
    @account.update_attributes params[:account]
    if @account.valid?
      flash[:success] = "&ldquo;#{@account.name}&rdquo; account updated"
      redirect_to accounts_path
    else
      flash[:error] = "Please see errors, below"
      render 'edit'
    end
  end

  def create
    @account = Account.create params[:account]
    if @account.valid?
      flash[:success] = "&ldquo;#{@account.name}&rdquo; account created"
      redirect_to accounts_path
    else
      flash[:error] = "Please see errors, below"
      render 'new'
    end
  end

  def transfer
    if request.post?
      account_from = Account.find(params[:from])
      account_to = Account.find(params[:to])
      Account.transfer(account_from, account_to, params[:amount])
      flash[:success] = "Transferred #{params[:amount]} from #{account_from.name} to #{account_to.name}"
    end
    render 'transfer'
  end

end
