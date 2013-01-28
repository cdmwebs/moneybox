class AccountsController < ApplicationController

  before_filter :set_collections

  def index
    @accounts = Account.all
  end

  def new
    @account = Account.new
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

  protected

    helper_method :set_collections

    def set_collections
      @envelopes = Envelope.all
      @accounts = Account.all
    end

end
