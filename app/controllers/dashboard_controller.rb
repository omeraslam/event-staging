class DashboardController < ApplicationController
  layout nil
  layout 'application', :except => :print


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

    @upcoming_events = @user.events.where("date_end > ?", Time.now.beginning_of_day)
    @events = @user.events.where("date_end < ?", Time.now.beginning_of_day)
  end


  def event

    #@import = Attendee::Import.new


    #@attendees = Attendee.all
    @attendees = Attendee.where(user_id:current_user.id.to_s, event_id:params[:event])

    @attendee = Attendee.new
    @attendee_count = Attendee.where(user_id:current_user.id.to_s, event_id:params[:event], attending: true).count()

    @event = Event.find_by id: params[:event]




    #User.where(name: 'David', occupation: 'Code Artist').order(created_at: :desc)
    logger.debug "ATTENDEE LIST IS: #{@attendees}"
    respond_to do |format|
      format.html
      format.csv { send_data @attendees.to_csv }
    end
    #respond_with(@attendees, @event)
  end

  def print

    @attendees = Attendee.where(user_id:current_user.id.to_s, event_id:params[:event])
    @event = Event.find_by id: params[:event]
    render :layout => false
 

  end


  def dashboard_delete



  end

  def profile

    @user = current_user
    


  end

end
