class EnvelopesController < ApplicationController

  def index
    @envelopes = Envelope.ordered
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

  def transfer
    if request.post?
      envelope_from = Envelope.find(params[:from])
      envelope_to = Envelope.find(params[:to])
      Envelope.transfer(envelope_from, envelope_to, params[:amount])
      flash[:success] = "Transferred #{params[:amount]} from #{envelope_from.name} to #{envelope_to.name}"
    end
    render 'transfer'
  end

  def fill
    if request.post?
      envelope_from = Envelope.find(params[:from])
      idx = 0
      params[:amount].each_pair do |id, amount|
        envelope_to = Envelope.find(id)
        Envelope.transfer(envelope_from, envelope_to, amount)
        idx += 1
      end
      flash[:success] = "Filled #{idx} envelopes from #{envelope_from.name}"
    end
    render 'fill'
  end

end
