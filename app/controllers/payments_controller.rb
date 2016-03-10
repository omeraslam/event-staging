class PaymentsController < ApplicationController
  layout nil
  layout 'application', :except => :print


  before_filter :authenticate_user!
  respond_to :html, :js, :json


  def upgrade

  end

  def thankyou
    @user = current_user
    customer = Stripe::Customer.retrieve(@user.customer_id)

   
    subscription = customer.subscriptions.retrieve(customer.subscriptions.data[0].id)
    @subscription = subscription

  end

  def cancel
    @user = current_user
  end

end
