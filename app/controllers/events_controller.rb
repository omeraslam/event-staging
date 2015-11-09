class EventsController < ApplicationController
  before_action :set_event, only: [:show,  :edit, :update, :destroy]
  after_filter :store_location
  before_filter :authenticate_user!, :except => [:show]


  respond_to :html, :js

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
    image_style_array = ['brunch','nyc', 'confetti', 'summer', 'flower', 'linen']
    @attendee = Attendee.new
    if(@event.layout_id?)
      @style_id =  @event.layout_id
      @style_layout =  @event.layout_style
    else 
      @style_id = '1'
      @style_layout = 'brunch'
    end
    # @background_style = 'home/'+ image_style_array[@style.to_i] +'.jpg'
    respond_with(@attendees)


  end

  def update_theme

    @user = User.find(current_user.id)
    @event = @user.events.find(params[:id])

    @event.layout_id = params[:layout_id]
    @event.layout_style = params[:layout_style]


    respond_to do |format|
      if @event.update(event_params)
        format.html {redirect_to user_event_path(current_user, @event)}
        format.json { render :show, status: :ok, location: user_event_path(current_user, @event) }
      else
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


    @user = User.find(params[:user_id])
    @event = @user.events.build(event_params)
    @event.user_id = current_user.id
    @event.style_id = params[:style_id]


    respond_to do |format|
      if @event.save
        format.html { redirect_to user_event_path(current_user, @event), notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: user_event_path(current_user, @event) }
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
    @event = @user.events.build(event_params)
    #@event.style_id = params[:style_id]

    # @event.layout_id = params[:layout_id]
    # @event.layout_style = params[:layout_style]


    respond_to do |format|
      if @event.update(event_params)
         format.html { redirect_to user_event_path(current_user, @event), notice: 'Event was successfully updated.' }
         format.json { render :show, status: :ok, location: user_event_path(current_user, @event) }
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
      format.html { redirect_to user_events_path, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @user = User.find(params[:user_id])
      @event = @user.events.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :description, :event_time, :time_display, :style_id, :layout_id, :layout_style, :location, :background_img)
    end
end
