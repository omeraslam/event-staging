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

    logger.debug "sub id: #{customer.subscriptions}"

    subscription = customer.subscriptions.retrieve(customer.subscriptions.data[0].id)
    @subscription = subscription
    logger.debug "sub id: #{subscription.plan.amount.to_i/100}"

  end

  def cancel
    @user = current_user
  end

end
