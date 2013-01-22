class EnvelopesController < ApplicationController

  def index
    @envelopes = Envelope.all
  end

end
