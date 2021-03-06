class DashboardController < ApplicationController
  layout nil
  layout 'application', :except => :print


  if !Rails.env.development?
    force_ssl
  end
  
  before_filter :authenticate_user!
  respond_to :html, :js, :json


  include ActionView::Helpers::NumberHelper

  def admin
    if !current_user.is_admin
      not_found
    end

      @events = Event.all
      events = []
      @events.each do |event|
        @user = User.find(event.user_id)
        @tickets = event.tickets.all 
        ticket_count = 0
        total_revenue = 0
        total_fee = 0
        @attendees = Attendee.where(:event_id => event.id)
        @tickets.each do |ticket|
          if ticket.is_active
            ticket_count += ticket.ticket_limit.nil? ? 0 : ticket.ticket_limit.to_i
          end

         Purchase.where(:event_id => event.id).all.each do |purchase|
            total_revenue += purchase.total_order.nil? ? 0 : purchase.total_order
            total_fee += purchase.total_fee.nil? ? 0 : purchase.total_fee

           # @total += LineItem.where(:purchase_id => purchase.id.to_s).count
          end
          
        end

        dataObj = {
          "Event Name" => event.name, 
          "Url" => 'http://www.eventcreate.com/'+event.slug+'?editing=true', 
          "Created At" => event.created_at.to_date.strftime("%B %d, %Y"),  
          "Updated At" => event.updated_at.to_date.strftime("%B %d, %Y"),  
          "User Email" => @user.email,  
          "Event Date" => event.date_start, 
          "Published" =>  event.published.to_s, 
          "Status" => event.status.to_s, 
          "Total Attendees" => @attendees.count,  
          "Spots Remaining" => ticket_count - @attendees.count, 
          "Total Sales" => '$' + (total_revenue/100).round(2).to_s, 
          "Total Fees" => '$' + (total_fee/100).to_s

        }
        events.push(dataObj)
       
      end


      @buyers_list = { "items" => events, "event" => 1} 


      @buyers_headers = ["Event Name", "Url", "Created At", "Updated At", "User Email", "Event Date", "Published", "Status", "Total Attendees", "Spots Remaining", "Total Sales", "Total Fees"]


      respond_to do |format|
        format.html
        format.js
      end

    
  end
    
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
      format.xls { send_data @buyers.to_csv  }
      format.csv { send_data @buyers.to_csv }
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

    @event = Event.find_by id: params[:event]

    @buyers = Purchase.where(:event_id => @event.id)
    render :layout => false
 

  end

  def print_attendees
    @attendees = Attendee.where(user_id:current_user.id.to_s, event_id:params[:event])
    @event = Event.find_by id: params[:event]
    render :layout => false

  end

  def print_attendees_csv
    @attendees_to_print = []
    @attendees = Attendee.where(user_id:current_user.id.to_s, event_id:params[:event])
    @attendees = @attendees.group('attendees.id')
    @event = Event.find_by id: params[:event]




      @attendees.each do |attendee| 

         @guest = LineItem.where(:id => attendee.line_item_id.to_s).first 

         @ticket = @guest.nil? ? nil : Ticket.find_by_id( @guest.ticket_id.to_i)
           
        attendeeObj =  {
          "first_name" => attendee.first_name,
          "last_name" => attendee.last_name,
          "email" => attendee.email,
          "ticket_type" => (@ticket.nil? ? 'N/A' : '"' + @ticket.title + '"'),
          "registration_date" => attendee.created_at.to_date.strftime("%B %d ")
        }


           @attendees_to_print.push(attendeeObj) 

     
       end



  
      respond_to do |format|
        format.html
        format.csv { send_data @attendees_to_print.to_csv("test.csv") }
        format.xls { send_data @attendees_to_print.to_csv(col_sep: "\t") }
      end
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
