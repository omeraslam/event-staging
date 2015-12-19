class EventsController < ApplicationController
  before_action :set_event, only: [ :edit]
  after_filter :store_location
  before_filter :authenticate_user!, :except => [:show]


  respond_to :html, :js, :json

  # GET /events
  # GET /events.json
  def index
    @attendee = Attendee.new
    @user = User.find(current_user.id)
    @events = Event.where(:user_id => current_user.id).all

  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find_by_slug(params[:slug])
    logger.debug "#{@event}"
    @user = User.find(@event.user_id)

    image_style_array = ['brunch','nyc', 'confetti', 'summer', 'flower', 'linen']
    @attendee = Attendee.new



    client = Bitly.client

    @url = 'http://eventcreate.com/' + event_path(current_user, @event)

    logger.debug "charge it to the game: #{@url}"
    @bitly = client.shorten(@url)


    if(!@event.layout_id?)
      @event.layout_id = '1'
      @event.layout_style = 'brunch'
    end
    # @background_style = 'home/'+ image_style_array[@style.to_i] +'.jpg'

    respond_with(@attendees, @event)

    # if @event.save

    # else 

    # end


  end

  def contact_host
    @guest_name = params[:name]
    @message = params[:message]
    @event = Event.find_by_slug(params[:slug])

    UserMailer.contact_host(current_user, @guest_name, @message, @event).deliver

    respond_with(@event, :location => slugger_url)
    # respond_to do |format|

    #   format.json { render :show, status: :ok, location: user_event_path(current_user, @event) }
    # end
  end

  def update_theme

    @user = User.find(current_user.id)
    @event = Event.find_by_slug(params[:id])


    # @event.layout_id = params[:layout_id]
    # @event.layout_style = params[:layout_style]




    # respond_to do |format|
    #   if @event.update(event_params)
    #     format.html {redirect_to user_event_path(current_user, @event)}
    #     format.json { render :show, status: :ok, location: user_event_path(current_user, @event) }
    #   else
    #     format.html {render :action => 'edit'}
    #     format.json {render :json => @user.errors.full_messages, :status => :unprocessable_entity}
    #   end
    # end


    respond_to do |format|
      if @event.update(event_params)
        #format.html { redirect_to event_path(current_user, @event), notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: slugger_path(@event.slug) }
      else

        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end

  end


  # GET /events/new
  def new

    if @is_premium != 'active' &&  @disable_create
      redirect_to pricing_path
    else 

      @user = User.find(current_user.id)
      @event = Event.all.build
      
    end 

  end

  # GET /events/1/edit
  def edit

  end

  # POST /events
  # POST /events.json
  # 
  def create


    @user = User.find(current_user)
    @event = Event.all.build(event_params)
    @event.user_id = current_user.id
    @event.style_id = params[:style_id]
    @event.layout_id = 1


    # client = Bitly.client
    # @url = client.shorten(params[:url])

    @event.layout_id = '1'
    @event.layout_style = 'brunch'
    @event.slug = @event.name.downcase.gsub(" ", "-")



    if Event.where(:user_id => current_user.id).count >= 0
      str = '?first=true'
    else
      str = ''
    end


    respond_to do |format|
      if @event.save
        format.html { redirect_to slugger_path(@event.slug) + str, notice: 'Event was successfully created.' }
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

    @user = User.find(params[:user_id])
    @event = Event.find_by_slug(params[:slug])
    #@event.style_id = params[:style_id]
    respond_to do |format|
      if @event.update(event_params)
         format.html { redirect_to event_path, notice: 'Event was successfully updated.' }
         format.js
         format.json { render :show, status: :ok, location: slugger_path(@event.slug) }
      else
         format.html { render :edit }
         format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find_by_slug(params[:id])
    @event.destroy
    respond_to do |format|

      format.html { redirect_to dashboard_index_path, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      #@user = User.find(params[:user_id])
      @event = Event.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      valid = params.require(:event).permit(:name, :description, :event_time, :date_start, :date_end, :time_start, :time_end, :time_display, :style_id,:layout_id, :layout_style, :location, :background_img, :show_custom, :slug)

      date_format = '%m/%d/%Y'
      #offset = Date.now.strftime("%z")
      if !valid[:date_start].nil?
        valid[:date_start] = valid[:date_start] != '' ? Date.strptime(valid[:date_start], date_format) : valid[:date_start]
        valid[:date_end] = valid[:date_end] != '' ? Date.strptime(valid[:date_end], date_format): valid[:date_end]
      end
      #valid[:time_start] = Time.strftime('1:00am', time_format)
      return valid
    end
  end
