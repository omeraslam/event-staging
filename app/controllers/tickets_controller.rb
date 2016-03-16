class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @tickets = Ticket.all
    respond_with(@tickets)
  end

  def show
    respond_with(@ticket)
  end

  def new
    @ticket = Ticket.new
    respond_with(@ticket)
  end

  def edit
  end

  def create
   # @ticket = Ticket.new(ticket_params)
    #@user = User.find(current_user)
    #@event = @user.events.build(event_params)
    #@event.user_id = current_user.id
    #
    @event = Event.find_by_slug(params[:slug])
    logger.debug "#{params[:slug]}"
    @ticket = @event.tickets.build(ticket_params)
    @ticket.save
    #respond_with(@ticket)
    redirect_to slugger_path(@event) + '?editing=true'
  end

  def update
    @ticket.update(ticket_params)
    respond_with(@ticket)
  end

  def destroy
    @ticket.destroy
    respond_with(@ticket)
  end

  private
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    def ticket_params
      params.require(:ticket).permit(:title, :description, :price, :ticket_limit, :buy_limit, :stop_date)
    end
end
