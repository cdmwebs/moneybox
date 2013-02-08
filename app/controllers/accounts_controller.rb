class AccountsController < ApplicationController

  def index
    @accounts = Account.all
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
      redirect_to root_path
    else
      flash[:error] = "Please see errors, below"
      render 'edit'
    end
  end

  def create
    @account = Account.create params[:account]
    if @account.valid?
      flash[:success] = "&ldquo;#{@account.name}&rdquo; account created"
      redirect_to root_path
    else
      flash[:error] = "Please see errors, below"
      render 'new'
    end
  end

end
