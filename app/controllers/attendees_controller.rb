class AttendeesController < ApplicationController
  before_action :set_attendee, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @attendees = Attendee.all
    respond_with(@attendees)
  end

  def show
    respond_with(@attendee)
  end

  def new
    @attendee = Attendee.new
    respond_with(@attendee)
  end

  def edit
  end

  def create
    @attendee = Attendee.new(attendee_params)
    @attendee.user_id = current_user.id;
    @attendee.event_id = params[:event_id]

    #@attendee.save

    respond_to do |format|
      if @attendee.save
        format.html { redirect_to attendees_path, notice: 'Attendee was successfully created.' }
        format.json { render :show, status: :created, location: attendees_path }
      else
        format.html { render :new }
        format.json { render json: @attendee.errors, status: :unprocessable_entity }
      end
    end

    #redirect_to :back
    #respond_with(@attendee)
  end

  def update
    @attendee.update(attendee_params)
    respond_with(@attendee)
  end

  def destroy
    @attendee.destroy
    respond_with(@attendee)
  end

  private
    def set_attendee
      @attendee = Attendee.find(params[:id])
    end

    def attendee_params
      params.require(:attendee).permit(:first_name, :last_name, :email, :phone_number, :message, :attending)
    end
end
