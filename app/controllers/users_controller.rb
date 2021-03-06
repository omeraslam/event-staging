class UsersController < ApplicationController
  
  #before_action :set_user, only: [:show, :edit, :update, :destroy]

  after_action :store_location
  before_action :authenticate_user!

  respond_to :html, :js, :json


  def charge_card

    @user = current_user

    # Get the credit card details submitted by the form
    token = params[:stripeToken]
    plan_type = params[:planType]

    if @user.customer_id.nil? 


      # Create a Customer
      customer = Stripe::Customer.create(
        :source => token,
        :plan => plan_type,
        :email => current_user.email,
        :description => 'Subscribed User'
      )

      @user.premium = true

      @user.customer_id = customer.id
    else

      customer = Stripe::Customer.retrieve(@user.customer_id)

    end 

    @user.subscription_id = customer.subscriptions.data[0].id
    @user.plan_type = plan_type

 
    if @user.update(user_params)
        render :js => "window.location = '/thank-you'"  #hack
    else
        #logger.debug "no set user to premium"
    end
    
  end

  def update_subscription

    @user = current_user
    plan_type = params[:planType]

    @user.premium = true


    customer = Stripe::Customer.retrieve(@user.customer_id)

    if(!@user.subscription_id.nil?)
    # if customer id has subscription id
      subscription = customer.subscriptions.retrieve(@user.subscription_id)
      subscription.plan = plan_type
      subscription.save
    else 
    # else create new one
      subscription = customer.subscriptions.create({:plan => plan_type})
      @user.subscription_id = subscription.id
    end
    
    @user.plan_type = plan_type


    if @user.update(user_params)
        render :js => "window.location = '/thank-you'"  #hack
    else
       # logger.debug "no plan updated"
    end

  end

  def cancel_subscription


    @user = current_user



    customer = Stripe::Customer.retrieve(@user.customer_id)

    customer.subscriptions.retrieve(customer.subscriptions.data[0].id).delete


    @user.premium = false
    @user.plan_type = nil
    @user.subscription_id = nil
    @user.customer_id = nil
    # 
    
    if @user.update(user_params)
      render :js => "window.location = '/dashboard/index'"  #hack
    else
      #logger.debug "plan not canceled"
    end
    
  end

  def update

    @user = current_user

    respond_to do |format|
      if @user.update(user_params)
         #format.html { redirect_to slugger_path(@event.slug), notice: 'Event was successfully updated.' }
         #format.html { redirect_to dashboard_event_path(:event => @event.id) + '#settings', event_success: 'Event details was successfully updated.'}
        format.html { redirect_to dashboard_profile_path , notice: 'Profile details was successfully updated.'}
        format.js
         #format.js   { render action: 'event-success', status: :created, location: dashboard_event_path(:event => @event.id) }
         #format.json { render :show, status: :ok, location: slugger_path(@event.slug) }
      else
        #format.html { redirect_to dashboard_event_path(:event => @event.id) + '#settings', notice: 'Event details was NOT updated =(' }

        # # added:
         #format.js   { render json: @event.errors, status: :unprocessable_entity }
        #format.js { render action: 'event-fail', status: :created, location: dashboard_event_path(:event => @event.id) }
        #  format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end

  end





  def update_password
    @user = User.find(current_user.id)

    respond_to do |format|
      if @user.update_with_password(user_params)
        sign_in @user, :bypass => true
        format.html { redirect_to dashboard_profile_path + '#members', notice: 'Password was successfully updated.' }
      else
        format.html { redirect_to dashboard_profile_path + '#members', :flash => { :error => 'Password could not be updated because: ' + @user.errors.full_messages.join(', ')}, notice: 'Password update failed.' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end


  
  end

  def update_email

    @user = User.find(current_user.id)

    respond_to do |format|
      if @user.update(user_params)
        #sign_in @user, :bypass => true
        format.html { redirect_to dashboard_profile_path + '#members', notice: 'Email was successfully updated.' }
      else
        format.html { redirect_to dashboard_profile_path + '#members', :flash => { :error => 'Email could not be updated because: ' + @user.errors.full_messages.join(', ')}, notice: 'Email update failed.' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end

  private
    def user_params
        params.require(:user).permit(:current_password,:password, :password_confirmation, :email, :subscription_id, :plan_type, :username, :description, :profile_img, :header_img, :tw_link, :fb_link)
    end


  # # GET /users/1
  # # GET /users/1.json
  # def show
  # end

  # private
  #   # Use callbacks to share common setup or constraints between actions.
  #   def set_user
  #     @user = User.find(params[:id])
  #   end

  #   # Never trust parameters from the scary internet, only allow the white list through.
  #   def user_params
  #     params.require(:user).permit(:email, :password)
  #   end

  #   def






end



  # # GET /users
  # # GET /users.json
  # def index
  #   @users = User.all
  # end



  # # GET /users/new
  # def new
  #   @user = User.new
  # end

  # # GET /users/1/edit
  # def edit
  # end

  # # POST /users
  # # POST /users.json
  # # 
  # def create
  #   @user = User.new(user_params)

  #   respond_to do |format|
  #     if @user.save
  #       format.html { redirect_to @user, notice: 'User was successfully created.' }
  #       format.json { render :show, status: :created, location: @user }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PATCH/PUT /users/1
  # # PATCH/PUT /users/1.json
  # def update
  #   respond_to do |format|
  #     if @user.update(user_params)
  #       format.html { redirect_to @user, notice: 'User was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @user }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /users/1
  # # DELETE /users/1.json
  # def destroy
  #   @user.destroy
  #   respond_to do |format|
  #     format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end


