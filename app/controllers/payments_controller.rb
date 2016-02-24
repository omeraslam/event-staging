class PaymentsController < ApplicationController
  layout nil
  layout 'application', :except => :print


  before_filter :authenticate_user!
  respond_to :html, :js, :json


  def upgrade

  end

  def thankyou

  end

  def cancel
    @user = current_user
  end

end
