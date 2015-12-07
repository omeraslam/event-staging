class ProfileController < ApplicationController


  before_filter :authenticate_user!
  respond_to :html, :js, :json

  def index
    @attendee = Attendee.new
    @user = User.find(current_user.id)
    @events = @user.events.where("date_end > ?", Time.now.beginning_of_day)


    respond_with(@attendee, @user, @events)
    # respond_to do |format|
    #   format.json 
      # if @event.update(event_params)
      #    #format.html { redirect_to user_event_path(current_user, @event), notice: 'Event was successfully updated.' }
      #    format.json { render :show, status: :ok, location: user_event_path(current_user, @event) }
      # else
      #    format.html { render :edit }
      #    format.json { render json: @event.errors, status: :unprocessable_entity }
      # end
    # end


  end

  def past
    @attendee = Attendee.new
    @user = User.find(current_user.id)
    @events = @user.events.where("date_end < ?", Time.now.beginning_of_day)
  end


  def event
     @attendees = Attendee.all
     @attendees = Attendee.where(user_id:current_user.id.to_s, event_id:params[:event])
     @event = Event.find_by id: params[:event]
      respond_with(@attendees, @event)
  end

  def profile
    
  end

end
