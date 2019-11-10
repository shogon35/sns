class RoomsController < ApplicationController
  # def show
  #   @messages = Message.all
  #   # @post = Message.find_by(id: params[:id])
  # end


  def index
    @rooms = Room.all.order(:id)
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages
  end

  def create
    @room = Room.new
    @room.save
    redirect_to("/rooms/index")
  end

end
