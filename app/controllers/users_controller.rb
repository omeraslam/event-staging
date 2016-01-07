class UsersController < ApplicationController
  
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  after_action :store_location
  before_action :authenticate_user!

  def charge_card

    @user = current_user
    @user.premium = true



     # Get the credit card details submitted by the form
    token = params[:stripeToken]


    logger.debug "charge it to the game: #{token}"

    # Create a Customer
    customer = Stripe::Customer.create(
      :source => token,
      :plan => 'premium',
      :email => current_user.email,
      :description => 'Test User'
    )

    # Charge the Customer instead of the card
    Stripe::Charge.create(
        :amount => 700, # in cents
        :currency => "usd",
        :customer => customer.id
    )

    @user.customer_id = customer.id
    @user.update(user_params)


    # # YOUR CODE: Save the customer ID and other info in a database for later!

    # # YOUR CODE: When it's time to charge the customer again, retrieve the customer ID!

    # Stripe::Charge.create(
    #   :amount   => 1500, # $15.00 this time
    #   :currency => "usd",
    #   :customer => customer_id # Previously stored, then retrieved
    # )
    
  end

  def cancel_subscription

     logger.debug "customer id: #{@cu.id}"
     logger.debug "subscription id: #{@cu.subscriptions.data[0].id}"

    customer = Stripe::Customer.retrieve(@cu.id)
    customer.subscriptions.retrieve(@cu.subscriptions.data[0].id).delete
    # 
    redirect_to dashboard_profile_path + '#billing'

  end


  def update_password
    @user = User.find(current_user.id)
    if @user.update(user_params)
      # Sign in the user by passing validation in case their password changed
      sign_in @user, :bypass => true
      redirect_to dashboard_profile_path + '#members'
    else
      render dashboard_profile_path + '#members'
    end
  end

  private
    def user_params
        params.require(:user).permit(:premium,:password, :password_confirmation, :email)
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


