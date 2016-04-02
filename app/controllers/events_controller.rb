
class EventsController < ApplicationController
  require "uri"
  require "net/http"
  #require 'chunky_png'

  # require 'barby'
  # require "barby/barcode/code_128"
  # require 'barby/outputter/png_outputter'

  layout "ticket", only: [:show_ticket]
  before_action :set_event, only: [ :edit]
  after_filter :store_location
  before_filter :authenticate_user!, :except => [:show, :export_events, :contact_host, :show_ticket]
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
     LineItem.count('ticket_id', :distinct => true)

    @user = User.where(:id => @event.user_id.to_i).first
    @account = Account.where(:user_id => @user.id).first 



     sum = 0 

     @line_items = LineItem.where(:purchase_id => params[:oid])
     @line_items.each do |line_item|
          @ticket = Ticket.where(:id => line_item.ticket_id.to_i).first
          sum += @ticket.price
     end 
                        

    @final_charge = sum * 100 #add all line items to figure out final price
end



def show_ticket

  #render layout: false
  @event = Event.find_by_slug(params[:slug])
  @purchase = Purchase.find(params[:oid].to_i )
  @line_items = LineItem.where(:purchase_id => params[:oid])



  #barcode = Barby::Code128B.new(params[:oid].to_s + @event.slug.to_s)
  # File.open('app/assets/images/bc/'+params[:oid].to_s + @event.slug.to_s + '.png', 'w'){|f|
  #   f.write barcode.to_png(:height => 20, :margin => 5)
  # }


  @tickets_per_page = 4
  respond_to do |format|
    format.html
    format.pdf do
      render pdf: "EventCreate_ORDER_" + @purchase.id.to_s+ "_" + @event.slug.to_s ,   # Excluding ".pdf" extension.
             template:                       'layouts/ticket.pdf.erb',
             orientation:                    'Portrait',
             page_width:                     1200
    end
  end
    

end

def stripe_redirect

  if signed_in?

     if params[:code]
        code = params[:code]
        # @resp = url to get token
        # 
        data   = {'grant_type' => 'authorization_code',
              'client_id' => ENV['STRIPE_CLIENT_ID'],
              'client_secret' => ENV['STRIPE_SECRET_KEY'],
              'code' => code
             }
             
        x = Net::HTTP.post_form(URI.parse('https://connect.stripe.com/oauth/token'), data)


        account_info = JSON.parse(x.body)

        puts account_info["access_token"]

        @access_object = x.body

        @access_token = account_info["access_token"]

        #account_info = OpenStruct.new(JSON.parse(x.body).to_json)

        #puts account_info.access_token

        # @access_token = @resp.token
        @user = current_user

        @account = Account.where(:user_id => @user.id).first 

        logger.debug "#{@account}"

        if !account_info["access_token"].nil?
          @account = Account.new
          @account.access_token = account_info["access_token"]
          @account.refresh_token = account_info["refresh_token"]
          @account.stripe_user_id = account_info["stripe_user_id"]
          @account.stripe_publishable_key = account_info["stripe_publishable_key"]
          @account.user_id = @user.id

          if @account.save
            logger.debug "save account"
            #render :js => "window.location = '/thank-you'"  #hack
          else
             # logger.debug "no plan updated"
          end
        end



      
      end
  end
  redirect_to session.delete(:return_to) + "?editing=true"
  #redirect_to slugger_path(@current_event.slug) + "?editing=true"



end

def complete_registration
  #save buyer attach to order

  @purchase = Purchase.find(params[:oid].to_i )
  @event = Event.where(:id => params[:event_id]).first


  # Set your secret key: remember to change this to your live secret key in production
  # See your keys here https://dashboard.stripe.com/account/apikeys
  # Stripe.api_key = ENV['STRIPE_SECRET_KEY']

  # Get the credit card details submitted by the form
  token = params[:stripeToken]
  amount = params[:purchaseAmount]



  @line_items = LineItem.where(:purchase_id => params[:oid])


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
      test = guest_item[1]['line_id']
      # respond_to do |format|
        if @attendee.save
          #save attendee_id to line_items
          #
          logger.debug "some guest item line id = #{guest_item[1]['line_id'].to_i}"
          @line_item = LineItem.where(:id => guest_item[1]['line_id'].to_i).first
          @line_item.attendee_id = @attendee.id

          line_params = { :attendee_id => @attendee.id}

          if @line_item.update(line_params)
          else
          end
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
          
          #format.html { redirect_to slugger_path(:slug => @event.slug), notice: 'Person was successfully created.' }
          # format.html { redirect_to show_confirm_path, notice: 'Ticket purchase successful'}
          # format.js   { render action: 'confirmation', status: :created, location: slugger_path(:slug => @event.slug) }
          # format.json { render :show, status: :created, location: :back }
          #send invite email to them now, thank you and sign up with hash
          #
        else
          logger.debug "not saving some guest item line id = #{guest_item[1]['line_id'].to_i}"
          
        #   format.html { render :new }
        #   format.json { render json: @attendee.errors, status: :unprocessable_entity }
        end
      #end


    end
  
  # create customer for user
  # save strip user id
  # 
  # 
  else
    #purchase wasn't updated and didn't go through
  end



    @account = Account.where(:user_id => @event.user_id.to_s).first

   

    logger.debug "AMOUNT IS EQUAL TO: #{amount}"


  UserMailer.send_tickets(@event, @purchase, @line_items).deliver unless @purchase.invalid?

    if params.has_key?(:purchaseAmount)
      begin

        charge = Stripe::Charge.create({
          :amount => amount,
          :currency => "usd",
          :source => token,
          :metadata => {"order_id" => @purchase.id, "purchse_email" => @purchase.email}
        }, {:stripe_account => @account.stripe_user_id})



      rescue Stripe::CardError => e
        # The card has been declined
      end

      render :js => "window.location = '/" + @event.slug + "/confirm" + "?oid=" + @purchase.id.to_s + "'"  #hack
    else
      redirect_to show_confirm_path(:oid => @purchase.id.to_s)
    end





end

def show_confirm 



  @purchase = Purchase.find(params[:oid].to_i )
  @event = Event.find_by_slug(params[:slug])
  @user = User.find(@event.user_id)

  @event = Event.find_by_slug(params[:slug])
  @purchase = Purchase.find(params[:oid].to_i )
  @line_items = LineItem.where(:purchase_id => params[:oid])

     
end

def select_tickets
  @event = Event.find_by_slug(params[:slug]) or not_found

  @purchase = Purchase.new

  if @purchase.save


    @event.tickets.all.each do |ticket|

      num_tickets = (params[:ticket_quantity][ticket.id.to_s]).to_i
      (1..num_tickets).each do |i| 
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
    end

  else

  end





  redirect_to show_buy_path(:oid =>@purchase)
end


def show

    session[:return_to] ||= request.path

    logger.debug "REQUEST PATH BE: #{session[:return_to]}"

     if signed_in?
      @user = current_user
      @account = Account.where(:user_id => @user.id).first.nil? ? nil : Account.where(:user_id => @user.id).first

    else
      @account = nil
    end
    @event = Event.find_by_slug(params[:slug]) or not_found


    @tickets = @event.tickets.all 
    @has_paid_ticket = false
    @tickets.each do |ticket|
      if ticket.price.to_i > 0  
        @has_paid_ticket = true
      end
    end
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
          @bitly = client.shorten(@url)  #airplane



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

    if @disable_create && !@premium_disable
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

  

  


    #########


    if Event.where(:user_id => current_user.id.to_s).count >= 0
      str = '?editing=true'
    else
      str = ''
    end


    respond_to do |format|
      if @event.save

          ticket_vars = {title: @event.name, stop_date: @event.date_start.nil? ? nil : @event.date_start , buy_limit: 4, ticket_limit: 1000, price: 0, description: nil  }
          @ticket = @event.tickets.build(ticket_vars)
          # @ticket = Ticket.new
          # @ticket.title = @event.name
          # @ticket.stop_date = @event.date_start
          # @ticket.buy_limit = 4
          # @ticket.ticket_limit = nil
          # @ticket.price = 0
          # @ticket.description = nil

          @ticket.save


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
         #format.html { redirect_to dashboard_event_path(:event => @event.id) + '#settings', event_success: 'Event details was successfully updated.'}
        format.html { redirect_to slugger_path(@event.slug, :editing => "true"), event_success: 'Event details was successfully updated.'}

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

    def line_item_params
      params[:line_item]
    end

    def account_params   
      params[:account]
    end

    def ticket_params
      params.require(:ticket).permit(:title, :description, :price, :ticket_limit, :buy_limit, :stop_date)
    end


  end
