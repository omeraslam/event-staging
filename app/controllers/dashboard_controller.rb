class DashboardController < ApplicationController


  before_filter :authenticate_user!
  respond_to :html, :js, :json

  def index
    @attendee = Attendee.new
    @user = User.find(current_user.id)
    @events = @user.events.where("time_end > ?", Time.now.beginning_of_day)
  end

  def past
    @attendee = Attendee.new
    @user = User.find(current_user.id)
    @events = @user.events.where("time_end < ?", Time.now.beginning_of_day)
  end


  def event
     @attendees = Attendee.all
     @attendees = Attendee.where(user_id:current_user.id.to_s, event_id:params[:event])
     @event = Event.find_by id: params[:event]
     #User.where(name: 'David', occupation: 'Code Artist').order(created_at: :desc)
    respond_with(@attendees, @event)

  end

end
