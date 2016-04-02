class DashboardController < ApplicationController
  layout nil
  layout 'application', :except => :print


  before_filter :authenticate_user!
  respond_to :html, :js, :json

  def index
    @attendee = Attendee.new
    @user = User.find(current_user.id)
    @events = Event.where(:user_id => current_user.id.to_s, :status => true).all

    @dir = true
    @welcome = params[:welcome]

    @sign_in_count = @user.sign_in_count

           #LineItem.where(:ticket_id => ticket.id.to_s).count
           # ticket.ticket_limit 




    respond_with(@attendee, @user, @events)
  end

  def contacts
    @contacts = Attendee.where('user_id' => current_user.id.to_s).all

  end

  def past
    @attendee = Attendee.new
    @user = User.find(current_user.id)

    @upcoming_events  = Event.where(user_id: current_user.id.to_s).where("date_end > ?", Time.now.beginning_of_day)
    @events = Event.where(user_id: current_user.id.to_s).where("date_end < ?", Time.now.beginning_of_day)
  end


  def event
    @user = current_user
    #@import = Attendee::Import.new

    @themes = Theme.all
    #@attendees = Attendee.all
    @attendees = Attendee.where(user_id:current_user.id.to_s, event_id:params[:event])

    @attendee = Attendee.new
    @attendee_count = Attendee.where(user_id:current_user.id.to_s, event_id:params[:event], attending: true).count()

    #@event = Event.find_by id: params[:event]
    @event = @user.events.find_by id: params[:event]


    @orders = Purchase.all


    #User.where(name: 'David', occupation: 'Code Artist').order(created_at: :desc)
   
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


  def upgrade
  end


  def thankyou


  end

end
