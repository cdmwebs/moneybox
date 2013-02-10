class EnvelopesController < ApplicationController

  def index
  end

  def show
    @envelope = Envelope.find params[:id]
  end

  def new
    @envelope = Envelope.new
  end

  def edit
    @envelope = Envelope.find params[:id]
  end

  def update
    @envelope = Envelope.find params[:id]
    @envelope.update_attributes params[:envelope]
    if @envelope.valid?
      flash[:success] = "&ldquo;#{@envelope.name}&rdquo; envelope updated"
      redirect_to envelopes_path
    else
      flash[:error] = "Please see errors, below"
      render 'edit'
    end
  end

  def create
    @envelope = Envelope.create params[:envelope]
    if @envelope.valid?
      flash[:success] = "&ldquo;#{@envelope.name}&rdquo; envelope created"
      redirect_to envelopes_path
    else
      flash[:error] = "Please see errors, below"
      render 'new'
    end
  end

end
