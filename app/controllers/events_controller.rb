
class EventsController < ApplicationController
  before_action :set_event, only: [ :edit]
  after_filter :store_location
  before_filter :authenticate_user!, :except => [:show, :export_events, :contact_host]
  require 'icalendar'


  respond_to :html, :js, :json

  # GET /events
  # GET /events.json
  def index
    @attendee = Attendee.new
    @user = User.find(current_user.id)
    @events = Event.where(:user_id => current_user.id.to_s).all

    @themes = Theme.all

  end

  # GET /events/1
  # GET /events/1.json
def show_buy 

     @event = Event.find_by_slug(params[:slug])
     @user = User.find(@event.user_id)
     @purchase = Purchase.find(params[:oid].to_i )

     @line_items = LineItem.where(:purchase_id => params[:oid])



end

def complete_registration
  #save buyer attach to order

  @purchase = Purchase.find(params[:oid].to_i )
  @event = Event.where(:id => params[:event_id]).first

  if @purchase.update(purchase_params)

    #save attendees
    
    guest_list = params[:attendees]

    guest_list.each do |guest_item|

      @attendee = Attendee.new
      @attendee.first_name = guest_item[1]['first_name']
      @attendee.last_name = guest_item[1]['last_name']
      @attendee.email = guest_item[1]['email']
      @attendee.phone_number = guest_item[1]['phone_number']
      @attendee.user_id = params[:user_id]
      @attendee.event_id = params[:event_id]
      @attendee.attending = true

      respond_to do |format|
        if @attendee.save
          #if not equal to host
           # if @attendee.id.to_s != @event.user_id.to_s
           #   #send guest rsvpd emails
           #   #UserMailer.welcome_attendee(@attendee, @event_url).deliver unless @attendee.invalid?
           #   #UserMailer.rsvp_update(@current_user, @attendee, @event_url).deliver unless @attendee.invalid?
           # else
           #   #send invitations sent emails
           #   #UserMailer.invitation_sent(current_user,@attendee, @event, @event_url).deliver unless @attendee.invalid?
           #   #UserMailer.guest_invitation_sent(current_user, @attendee, @event, @event_url).deliver unless @attendee.invalid?
           # end
          
          format.html { redirect_to slugger_path(:slug => @event.slug), notice: 'Person was successfully created.' }
          format.js   { render action: 'confirmation', status: :created, location: slugger_path(:slug => @event.slug) }
          format.json { render :show, status: :created, location: :back }
          #send invite email to them now, thank you and sign up with hash
          #
        else
          format.html { render :new }
          format.json { render json: @attendee.errors, status: :unprocessable_entity }
        end
      end
    end
  
  # create customer for user
  # save strip user id
  # 
  # 
  else
    #purchase wasn't updated and didn't go through
  end

end

def show_confirm 

     @event = Event.find_by_slug(params[:slug])
     @user = User.find(@event.user_id)


end

def select_tickets
  @event = Event.find_by_slug(params[:slug]) or not_found

  @purchase = Purchase.new

  if @purchase.save
    @event.tickets.all.each do |ticket|
      @line_item = LineItem.new
      @quantity = params[:ticket_quantity][ticket.id.to_s]
     
      ticket_id = params[:ticket_id][ticket.id.to_s]

      @line_item.ticket_id = ticket_id
      @line_item.quantity = @quantity
      @line_item.purchase_id = @purchase.id.to_s

      if @line_item.save


      else
                
      end
    end

  else

  end





  redirect_to show_buy_path(:oid =>@purchase)
end


def show

    @event = Event.find_by_slug(params[:slug]) or not_found

    @tickets = @event.tickets.all 
    #@ticket = @event.tickets.build(ticket_params)
    @ticket = Ticket.new
    @purchase = Purchase.new

    if !@event

      render_404
    else 

       #@event = Event.where('id' => 70)
      #@event = Event.find(request.subdomain)
      if @event.published == false && !signed_in?
          #&& current_user.id.to_i != @event.user_id.to_i
          redirect_to root_path
      else  
        @user = User.find(@event.user_id)

          image_style_array = ['wedding','concert', 'gala', 'party', 'sport', 'other']
          @attendee = Attendee.new



          client = Bitly.client
          @url = 'http://eventcreate.com' + slugger_path( @event)
          @bitly = client.shorten(@url)



          if(!@event.layout_style?)
            @event.layout_id = '1'
            @event.layout_style = 'default'
          end

          respond_with(@attendees, @event)
      end

      @themes = Theme.all

    end
   

  end

  # send contact an email
  def contact_host
    @email = params[:name]
    @message = params[:message]
    @event = Event.find_by_slug(params[:slug])

    UserMailer.contact_host(@email, @message, @event).deliver

    respond_with(@event, :location => slugger_url)

  end

  def update_theme

    @user = User.find(current_user.id)
    @event = Event.find_by_slug(params[:slug])



    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to slugger_path(@event.slug), notice: 'Event was successfully updated.' }
        format.js
        format.json { render :show, status: :ok, location: slugger_path(@event.slug) }
      else

        # "no save"
        #format.html { render :edit }
        #format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end

  end

  def unsplash_search

    @search_results = Unsplash::Photo.search(params[:searchTerm])

    render json: @search_results

  end


  # GET /events/new
  def new


    @themes = Theme.all

    if @disable_create
       redirect_to pricing_path
    else 

      @user = User.find(current_user.id)
      @event = Event.all.build
      
    end 

    @themes = Theme.all

  end

  # GET /events/1/edit
  def edit

    @themes = Theme.all

  end

  # POST /events
  # POST /events.json
  # 
  def create

    @themes = Theme.order(:id).all

    @user = User.find(current_user)
    @event = @user.events.build(event_params)
    @event.user_id = current_user.id
    @event.layout_id = '1'

  



    if Event.where(:user_id => current_user.id.to_s).count >= 0
      str = '?editing=true'
    else
      str = ''
    end


    respond_to do |format|
      if @event.save
        format.html { redirect_to slugger_path(@event) + str, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: event_path(current_user, @event) }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def check_slug

    @event_exists = Event.exists?( slug: params[:slug])

    if @event_exists
      flash[:notice] = 'Task was successfully created.' 
    end

    respond_with(@event)


  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update

    #@user = User.find(params[:user_id])
    @event = Event.find_by_slug(params[:id])
    respond_to do |format|
      if @event.update(event_params)
         #format.html { redirect_to slugger_path(@event.slug), notice: 'Event was successfully updated.' }
         format.html { redirect_to dashboard_event_path(:event => @event.id) + '#settings', event_success: 'Event details was successfully updated.'}
         format.js   { render action: 'event-success', status: :created, location: dashboard_event_path(:event => @event.id) }
         format.json { render :show, status: :ok, location: slugger_path(@event.slug) }
      else
        format.html { redirect_to dashboard_event_path(:event => @event.id) + '#settings', notice: 'Event details was NOT updated =(' }

        # # added:
         format.js   { render json: @event.errors, status: :unprocessable_entity }
        format.js { render action: 'event-fail', status: :created, location: dashboard_event_path(:event => @event.id) }
        #  format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end





  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    #@event.destroy
    @event.published = false
    @event.status = false
    respond_to do |format|

      if @event.save

        format.html { redirect_to controller: 'dashboard', action: 'index', notice: 'Event was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  def export_events

     @event = Event.find_by_slug(params[:slug])

     @calendar = Icalendar::Calendar.new
     event = Icalendar::Event.new
    event.dtstart = @event.date_start.to_date.strftime("%Y%m%d") + (@event.time_start.blank? || @event.time_start.nil? ? 'T000000': @event.time_start.to_time.strftime("T%H%M%S") )
     event.dtend = ((!@event.date_end.blank?) ? @event.date_end.to_date.strftime("%Y%m%d"): @event.date_start.to_date.strftime("%Y%m%d") ) + (@event.time_end.nil? || @event.time_end.blank? ? 'T000000': @event.time_end.to_time.strftime("T%H%M%S"))
  
     event.summary = @event.name
     event.description = @event.description
     event.location = @event.location
     @calendar.add_event(event)
     @calendar.publish
     headers['Content-Type'] = "text/calendar; charset=UTF-8"
     render :layout => false, :text => @calendar.to_ical
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      #@user = User.find(params[:user_id])
      @event = Event.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      valid = params.require(:event).permit(:name, :event_time, :date_start, :date_end, :time_start, :time_end, :time_display,:layout_id, :layout_style, :background_img, :show_custom, :slug, :location, :location_name, :description, :published, :host_name, :bg_opacity, :bg_color, :font_type, :external_image, :status)


      date_format = '%m/%d/%Y'
      if !valid[:date_start].nil?
        valid[:date_start] = valid[:date_start] != '' ? Date.strptime(valid[:date_start], date_format) : valid[:date_start]
        valid[:date_end] = valid[:date_end] != '' ? Date.strptime(valid[:date_end], date_format): valid[:date_end]
      end

      # if !valid[:name].nil? || !valid[:name].blank?
      #   valid = false
      # end
      return valid
    end

    def purchase_params
      params.require(:purchase).permit( :email, :first_name, :last_name, :phone_number, :oid)
    end

  end
