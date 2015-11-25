class EventsController < ApplicationController
  before_action :set_event, only: [:show,  :edit, :update, :destroy]
  after_filter :store_location
  before_filter :authenticate_user!, :except => [:show]


  respond_to :html, :js, :json

  # GET /events
  # GET /events.json
  def index



    @attendee = Attendee.new
    @user = User.find(current_user.id)
    @events = @user.events

  end

  # GET /events/1
  # GET /events/1.json
  def show
    # if @current_user.blank?
    #   format.html { render :show }
    # else
    #   format.json { render :show }
    # end

    image_style_array = ['brunch','nyc', 'confetti', 'summer', 'flower', 'linen']
    @attendee = Attendee.new

  
    if(!@event.layout_id?)
       @event.layout_id = '1'
       @event.layout_style = 'brunch'
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event}
    end


    # if @event.save

    # else 

    # end


  end

  def update_theme

    @user = User.find(current_user.id)
    @event = @user.events.find_by_slug(params[:id])

    # @event.layout_id = params[:layout_id]
    # @event.layout_style = params[:layout_style]




    # respond_to do |format|
    #   if @event.update(event_params)
    #     format.html {redirect_to event_path(current_user, @event)}
    #     format.json { render :show, status: :ok, location: event_path(current_user, @event) }
    #   else
    #     format.html {render :action => 'edit'}
    #     format.json {render :json => @user.errors.full_messages, :status => :unprocessable_entity}
    #   end
    # end


    respond_to do |format|
      if @event.update(event_params)
         #format.html { redirect_to event_path(current_user, @event), notice: 'Event was successfully updated.' }
         format.json { render :show, status: :ok, location: event_path(current_user, @event) }
      else
         format.html { render :edit }
         format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end

  end


  # GET /events/new
  def new
    @user = User.find(current_user.id)
    @event = @user.events.build
  end

  # GET /events/1/edit
  def edit
    
  end

  # POST /events
  # POST /events.json
  # 
  def create


    @user = User.find(current_user)
    @event = @user.events.build(event_params)
    @event.user_id = current_user.id
    @event.style_id = params[:style_id]




    respond_to do |format|
      if @event.save
        format.html { redirect_to event_path(current_user, @event), notice: 'Event was successfully created.' }
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
    @event = @user.events.find_by_slug(params[:id])
    #@event.style_id = params[:style_id]

    # 
    
   


    respond_to do |format|
      if @event.update(event_params)
         format.html { redirect_to event_path, notice: 'Event was successfully updated.' }
         format.js
         format.json { render :show, status: :ok, location: event_path(current_user, @event) }
      else
         format.html { render :edit }
         format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_path, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      #@user = User.find(params[:user_id])
      @event = Event.find_by_slug(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      valid = params.require(:event).permit(:name, :description, :event_time, :date_start, :date_end, :time_start, :time_end, :time_display, :style_id,:layout_id, :layout_style, :location, :background_img, :show_custom)

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
