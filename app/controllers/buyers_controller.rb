class BuyersController < ApplicationController
  before_action :set_buyer, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @buyers = Buyer.all
    respond_with(@buyers)
  end

  def show
    respond_with(@buyer)
  end

  def new
    @buyer = Buyer.new
    respond_with(@buyer)
  end

  def edit
  end

  def create
    @buyer = Buyer.new(buyer_params)
    @buyer.save
    respond_with(@buyer)
  end

  def update
    @buyer.update(buyer_params)
    respond_with(@buyer)
  end

  def destroy
    @buyer.destroy
    respond_with(@buyer)
  end

  private
    def set_buyer
      @buyer = Buyer.find(params[:id])
    end

    def buyer_params
      params.require(:buyer).permit(:first_name, :last_name, :email)
    end
end
