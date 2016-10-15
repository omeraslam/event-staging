class CouponsController < ApplicationController
  before_action :set_coupon, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @coupons = Coupon.all
    respond_with(@coupons)
  end

  def show
    #respond_with(@coupon)
    
    @event = Event.find(params[:event_id])
    redirect_to slugger_path(@event) + '?editing=true'
  end

  def new
    @coupon = Coupon.new
    respond_with(@coupon)
  end

  def edit
  end

  def create
    @coupon = Coupon.new(coupon_params)
    @event = Event.find(params[:event_id])
    @coupon.event_id = (params[:event_id]).to_i


    @coupon.save
    redirect_to slugger_path(@event) + '?editing=true'
  end

  def update
    @coupon.event_id = (params[:event_id]).to_i

    @coupon.promo_code = @coupon.promo_code.gsub(/\s+/, '')
    @coupon.promo_code = @coupon.promo_code.upcase

    @coupon.update(coupon_params)
    @event = Event.find(params[:event_id])
    redirect_to slugger_path(@event) + '?editing=true'
  end

  def destroy
    @coupon.destroy
    respond_with(@coupon)
  end

  private
    def set_coupon
      @coupon = Coupon.find(params[:id])
    end

    def coupon_params
      valid = params.require(:coupon).permit(:promo_code, :discount, :coupon_type, :event_id, :is_fixed, :is_active)

      valid[:promo_code] = valid[:promo_code].upcase

      return valid


    end
end