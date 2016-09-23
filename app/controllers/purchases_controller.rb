class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @purchases = Purchase.all
    respond_with(@purchases)
  end

  def show
    respond_with(@purchase)
  end

  def new
    @purchase = Purchase.new
    respond_with(@purchase)
  end

  def edit
  end

  def create
    @purchase = Purchase.new(purchase_params)
    @purchase.save
    respond_with(@purchase)
  end

  def update
    @purchase.update(purchase_params)
    respond_with(@purchase)
  end

  def destroy
    @purchase.destroy
    @event = Event.find_by_slug(params[:slug])
    redirect_to slugger_path(@event) + '?editing=true'
    #respond_with(@purchase)
  end

  private
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    def purchase_params
      params[:purchase]
    end
end
