

class EventsController < ApplicationController
  before_action :set_event, only: [ :edit]
  after_filter :store_location
  before_filter :authenticate_user!, :except => [:show]
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
  def show

    @event = Event.find_by_slug(params[:slug])
    #@event = Event.where('id' => 70)
    #@event = Event.find(request.subdomain)
    # if @event.published == false && !signed_in?
    #     #&& current_user.id.to_i != @event.user_id.to_i
    #     redirect_to root_path
    # else  
        @user = User.find(@event.user_id)

        image_style_array = ['cityscape','getloud', 'epic', 'celebrate', 'gallery', 'minimalist']
        @attendee = Attendee.new



        client = Bitly.client
        @url = 'http://eventcreate.com' + slugger_path( @event)
        @bitly = client.shorten(@url)


        if(!@event.layout_style?)
          @event.layout_id = '1'
          @event.layout_style = 'cityscape'
        end

        respond_with(@attendees, @event)
    #end

    @themes = Theme.all

  end

  def contact_host
    @guest_name = params[:name]
    @message = params[:message]
    @event = Event.find_by_slug(params[:slug])

    UserMailer.contact_host(current_user, @guest_name, @message, @event).deliver

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

        logger.debug "no save"
        #format.html { render :edit }
        #format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end

  end


  # GET /events/new
  def new


    @themes = Theme.all

    # if @is_premium != 'active' &&  @disable_create
    #   redirect_to pricing_path
    # else 

      @user = User.find(current_user.id)
      @event = Event.all.build
      
   # end 

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


    @themes = Theme.all

    @user = User.find(current_user)
    @event = Event.all.build(event_params)
    @event.user_id = current_user.id
    @event.layout_id = '1'
    @event.slug = @event.name.downcase.gsub(" ", "-")
    @event.slug = @event.slug.gsub(/\W/, '')





    if Event.where(:user_id => current_user.id.to_s).count >= 0
      str = '?first=true'
    else
      str = ''
    end


    respond_to do |format|
      if @event.save
        format.html { redirect_to controller: 'dashboard', action: 'index', event: @event.id, first: true, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: event_path(current_user, @event) }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update

    #@user = User.find(params[:user_id])
    @event = Event.find_by_slug(params[:id])
    respond_to do |format|
      if @event.update(event_params)
         #format.html { redirect_to slugger_path(@event.slug), notice: 'Event was successfully updated.' }
         format.html { redirect_to dashboard_event_path(:event => @event.id) + '#settings', notice: 'Event was successfully updated.'}
         format.js
         format.json { render :show, status: :ok, location: slugger_path(@event.slug) }
      else
         format.html { render :edit }
         format.js
         format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    respond_to do |format|

      format.html { redirect_to controller: 'dashboard', action: 'index', notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def export_events
    @event = Event.find_by_slug(params[:slug])

    @calendar = Icalendar::Calendar.new
    event = Icalendar::Event.new

    event.dtstart = @event.date_start.to_date.strftime("%Y%m%dT%H%M%S")
    #event.end = @event.dt_time.strftime("%Y%m%dT%H%M%S")
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
      valid = params.require(:event).permit(:name,  :event_time, :date_start, :date_end, :time_start, :time_end, :time_display,:layout_id, :layout_style,  :background_img, :show_custom, :slug, :location, :location_name, :description, :published)

      date_format = '%m/%d/%Y'
      if !valid[:date_start].nil?
        valid[:date_start] = valid[:date_start] != '' ? Date.strptime(valid[:date_start], date_format) : valid[:date_start]
        valid[:date_end] = valid[:date_end] != '' ? Date.strptime(valid[:date_end], date_format): valid[:date_end]
      end
      return valid
    end
  end
