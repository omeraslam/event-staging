class DashboardController < ApplicationController
  layout nil
  layout 'application', :except => :print


  before_filter :authenticate_user!
  respond_to :html, :js, :json


  include ActionView::Helpers::NumberHelper
    
  def index
    @attendee = Attendee.new
    @user = User.find(current_user.id)
    @events = Event.where(:user_id => current_user.id.to_s, :status => true).all

    @dir = true
    @welcome = params[:welcome]

    @sign_in_count = @user.sign_in_count

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
    @orders = Purchase.where.not(first_name: nil, last_name:nil, email: nil).where(event_id: @event.id)
    
    @buyers = Purchase.where(:event_id => @event.id)

    #User.where(name: 'David', occupation: 'Code Artist').order(created_at: :desc)
    #
    #
    

      @attendees_list = {
        "attendees" => [],
        "event" => {
          "event_id" => @event.id,
          "name" => @event.name,
          "date_start" => @event.date_start.to_date.strftime("%B %d, %Y")
          } 
      }             
   

    @attendees.each do |attendee|
      @guest = LineItem.where(:id => attendee.line_item_id.to_i).first
      @ticket = @guest.nil? ? nil : Ticket.find_by_id( @guest.ticket_id.to_i)
      attendee_block = {
          "id" => attendee.id,
          "first_name" => attendee.first_name,
          "last_name" => attendee.last_name,
          "email" => attendee.email,
          "created_at" => attendee.created_at.to_date.strftime("%B %d, %Y "),
          "ticket_type" => @ticket.nil? ? 'n/a' : '"'+@ticket.title+'"'
        }

        @attendees_list["attendees"].push(attendee_block)

    end

    logger.debug "#{@attendees_list}"


   
    respond_to do |format|
      format.html
      format.csv { send_data @attendees_list["attendees"].to_csv }
    end
    #respond_with(@attendees, @event)
  end

  def print


    @event = Event.find_by id: params[:event]

      @attendees_list = {
        "attendees" => [],
        "event" => {
          "event_id" => @event.id,
          "name" => @event.name,
          "date_start" => @event.date_start.to_date.strftime("%B %d, %Y")
          } 
      }             
   
    @attendees = Attendee.where(user_id:current_user.id.to_s, event_id:params[:event])

    @attendees.each do |attendee|
      @guest = LineItem.where(:id => attendee.line_item_id.to_i).first
      @ticket = @guest.nil? ? nil : Ticket.find_by_id( @guest.ticket_id.to_i)
      attendee_block = {
          "id" => attendee.id,
          "first_name" => attendee.first_name,
          "last_name" => attendee.last_name,
          "email" => attendee.email,
          "created_at" => attendee.created_at.to_date.strftime("%B %d, %Y "),
          "ticket_type" => @ticket.nil? ? 'n/a' : '"'+@ticket.title+'"'
        }

        @attendees_list["attendees"].push(attendee_block)

    end

    logger.debug "#{@attendees_list}"



    @buyers = Purchase.where(:event_id => @event.id)
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
