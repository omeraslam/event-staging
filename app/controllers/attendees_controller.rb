class AttendeesController < ApplicationController
  before_action :set_attendee, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index

    @attendees = Attendee.all
     @attendees = Attendee.where(user_id:current_user.id.to_s, event_id:params[:event])
     #User.where(name: 'David', occupation: 'Code Artist').order(created_at: :desc)
    respond_with(@attendees)
  end

  def show
    respond_with(@attendee)
  end

  def new
    @attendee = Attendee.new
    @attendee.event_id = params[:event]
    respond_with(@attendee)
  end

  def edit
  end

  def create

    @attendee = Attendee.new(attendee_params)
    @attendee.user_id = current_user.id;
    @event = Event.find_by id: params[:event_id]
    @event_url = 'http://localhost:3000/users/' +  @attendee.user_id.to_s + '/events/' +  @event.id.to_s



    #@attendee.save

    respond_to do |format|
      if @attendee.save
        #if not equal to host
         if current_user.id.to_s != @event.user_id.to_s
           #send guest rsvpd emails
           UserMailer.welcome_attendee(@attendee, @event_url).deliver unless @attendee.invalid?
           UserMailer.rsvp_update(current_user, @attendee, @event_url).deliver unless @attendee.invalid?
         else
           #send invitations sent emails
           UserMailer.invitation_sent(current_user,@attendee, @event, @event_url).deliver unless @attendee.invalid?
           UserMailer.guest_invitation_sent(current_user, @attendee, @event, @event_url).deliver unless @attendee.invalid?
         end
        
        format.html { redirect_to :back }
        format.json { render :show, status: :created, location: :back }
        #send invite email to them now, thank you and sign up with hash
        #
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
    redirect_to :back
    #respond_with(@attendee)
  end

  private
    def set_attendee
      @attendee = Attendee.find(params[:id])
    end

    def attendee_params
      params.require(:attendee).permit(:first_name, :last_name, :email, :phone_number, :message, :attending)
    end
end
