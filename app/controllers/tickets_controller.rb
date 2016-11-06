class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  respond_to :html, :js

  def index
    @tickets = Ticket.all
    respond_with(@tickets)
  end

  def show
    respond_with(@ticket)
  end

  def new
    @ticket = Ticket.new
    @slug = params[:event]
    respond_with(@ticket)
  end

  def edit
      #redirect_to dashboard_index_path
       # format.html { render action: 'edit' }
       # 
      respond_to do |format|
        format.js 
       #format.json { render json: @user.errors, status: :unprocessable_entity }
      end
  end

  def create
   # @ticket = Ticket.new(ticket_params)
    #@user = User.find(current_user)
    #@event = @user.events.build(event_params)
    #@event.user_id = current_user.id
    #
    @event = Event.find_by_slug(params[:slug])
    @slug = params[:slug]
    logger.debug "#{params[:slug]}"
    @ticket = @event.tickets.build(ticket_params)
    @ticket.save
    #respond_with(@ticket)
    redirect_to slugger_path(@event) + '?editing=true'
  end

  def update
    @ticket.update(ticket_params)
    @event = Event.find(@ticket.event_id)
    respond_to do |format|
      format.html { redirect_to slugger_path(@event) + '?editing=true', notice: 'Person was successfully created.' }
      format.js   { render action: 'confirmation', status: :created, location: slugger_path(@event) + '?editing=true' }
      format.json { render :show, status: :created }
    end
  end

  def destroy
    
    @event = Event.find(@ticket.event_id)
    @ticket.destroy

    redirect_to slugger_path(@event) + '?editing=true'

    #respond_with(@ticket)
  end

  private
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    def ticket_params
      valid = params.require(:ticket).permit(:title, :description, :price, :ticket_limit, :buy_limit, :stop_date, :is_active)

      date_format = '%m/%d/%Y'
      if !valid[:stop_date].nil?
        valid[:stop_date] = valid[:stop_date] != '' ? Date.strptime(valid[:stop_date], date_format) : valid[:stop_date]
      end

      # if !valid[:name].nil? || !valid[:name].blank?
      #   valid = false
      # end
      return valid

    end



end
