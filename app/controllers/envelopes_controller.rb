class EnvelopesController < ApplicationController

  def index
    @envelopes = Envelope.all
  end

  def show
    @envelope = Envelope.find params[:id]
  end

end
