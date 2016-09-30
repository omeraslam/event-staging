
class EventsController < ApplicationController
  require "uri"
  require "net/http"

  include ActionView::Helpers::NumberHelper

  
  #before_filter :find_subdomain, only: [ :home]
  before_filter :find_site, only: [:home]

  #require 'chunky_png'

  require 'barby'
  require "barby/barcode/code_128"
  require 'barby/outputter/png_outputter'


  # Controller
#require 'rqrcode'
require 'rqrcode_png'  

 


  layout "ticket", only: [:show_ticket]
  before_action :set_event, only: [ :edit]
  after_filter :store_location
  before_filter :authenticate_user!, :except => [:show, :export_events, :home, :contact_host, :show_ticket, :select_tickets, :show_buy, :complete_registration, :show_ticket, :show_confirm]
  require 'icalendar'


  respond_to :html, :js, :json

  # GET /events
  # GET /events.json
  def index
    @attendee = Attendee.new
    @user = User.find(current_user.id)
    @events = Event.where(:user_id => current_user.id.to_s).all

    @themes = Theme.all

  end

  def home
    logger.debug "USER:::: #{@user.nil? }"
   
    if @user.nil?
        redirect_to root_url(subdomain: 'www')
    else
        @events = Event.where(:user_id => @user.id.to_s, :published => true).all
    end

    #@user = User.find(params[:id])

  end

  # GET /events/1
  # GET /events/1.json
def show_buy 

     @event = Event.find_by_slug(params[:slug])
     @user = User.find(@event.user_id)
     @tickets = Ticket.where(:event_id => @event.id)
    #  @purchase = Purchase.find(params[:oid].to_i )

    #  @line_items = LineItem.where(:purchase_id => params[:oid])
    #  LineItem.count('ticket_id', :distinct => true)

    # @user = User.where(:id => @event.user_id.to_i).first
    # @account = Account.where(:user_id => @user.id).first 



    #  sum = 0 

    #  @line_items = LineItem.where(:purchase_id => params[:oid])
    #  @line_items.each do |line_item|
    #       @ticket = Ticket.where(:id => line_item.ticket_id.to_i).first
    #       sum += @ticket.price
    #  end 
                        

    # @final_charge = sum * 100 #add all line items to figure out final price
end

def confirm_ticket

  if signed_in?
    @user = current_user
  end
   
  @event = Event.find_by_slug(params[:slug])



  if @event.user_id != @user.id.to_s || !signed_in?
      #&& current_user.id.to_i != @event.user_id.to_i
      redirect_to root_path
  else  


    @purchase = Purchase.where(:confirm_token => params[:oid])
    @line_item = LineItem.where(:id => params[:luid].to_i).first

    if @line_item.redeemed == false
      @line_item.redeemed = true
      @line_item.save
      @status = "CONFIRMED"
    else
      @status = "ALREADY USED"
    end
  end

end


def show_ticket

  #render layout: false
  @event = Event.find_by_slug(params[:slug])
  @purchase = Purchase.where(:confirm_token => params[:oid].to_s ).first
  @line_items = LineItem.where(:purchase_id => @purchase.id.to_s)



  barcode = Barby::Code128B.new(params[:oid].to_s + @event.slug.to_s)
  File.open('app/assets/images/bc/'+params[:oid].to_s + @event.slug.to_s + '.png', 'w'){|f|
    f.write barcode.to_png(:height => 20, :margin => 5)
  }

     @qr_codes = []
        @line_items.each do |lineitem|
          logger.debug "#{@purchase.confirm_token.to_s + ' || - || ' + @event.slug.to_s + lineitem.id.to_s}"
          qr  = RQRCode::QRCode.new('http://www.eventcreate.com/' + @event.slug.to_s + '/confirm-ticket?oid='+ @purchase.confirm_token.to_s + '&luid=' + lineitem.id.to_s).to_img.resize(200, 200).to_data_url
          @qr_codes.push(qr)
        end 


 logger.debug "QRRRRRR : #{@qr}"
  @tickets_per_page = 4
  respond_to do |format|
    format.html
    format.pdf do
      render pdf: "EventCreate_ORDER_" + @purchase.id.to_s+ "_" + @event.slug.to_s ,   # Excluding ".pdf" extension.
             template:                       'layouts/ticket.pdf.erb',
             orientation:                    'Portrait',
             page_width:                     1200
    end
  end
    

end

def stripe_redirect

  if signed_in?

     if params[:code]
        code = params[:code]
        # @resp = url to get token
        # 
        data   = {'grant_type' => 'authorization_code',
              'client_id' => ENV['STRIPE_CLIENT_ID'],
              'client_secret' => ENV['STRIPE_SECRET_KEY'],
              'code' => code
             }
             
        x = Net::HTTP.post_form(URI.parse('https://connect.stripe.com/oauth/token'), data)


        account_info = JSON.parse(x.body)

        puts account_info["access_token"]

        @access_object = x.body

        @access_token = account_info["access_token"]

        #account_info = OpenStruct.new(JSON.parse(x.body).to_json)

        #puts account_info.access_token

        # @access_token = @resp.token
        @user = current_user

        @account = Account.where(:user_id => @user.id).first 


        if !account_info["access_token"].nil?
          @account = Account.new
          @account.access_token = account_info["access_token"]
          @account.refresh_token = account_info["refresh_token"]
          @account.stripe_user_id = account_info["stripe_user_id"]
          @account.stripe_publishable_key = account_info["stripe_publishable_key"]
          @account.user_id = @user.id

          if @account.save
            logger.debug "save account"
            #render :js => "window.location = '/thank-you'"  #hack
          else
             # logger.debug "no plan updated"
          end
        end



      
      end
  end
  redirect_to session.delete(:return_to) + "?editing=true"
  #redirect_to slugger_path(@current_event.slug) + "?editing=true"



end

def check_coupon

  @code = params[:couponCode]


  @coupon = get_coupon(@code, params[:eventId])

  logger.debug "coupon wow: #{@coupon}"
  if !@coupon.nil?
    if @coupon.is_fixed == true
      @return_obj = {status: "ok", message: "Discount applied: $" + (number_with_precision(@coupon.discount, precision: 2)).to_s + ' off!', is_fixed: @coupon.is_fixed, discount: @coupon.discount}
    else

      @return_obj = {status: "ok", message: "Discount applied: "+(number_with_precision(@coupon.discount, precision: 0)).to_s + "% off!", is_fixed: @coupon.is_fixed, discount: @coupon.discount}
    end
  else
    @return_obj = {status: "error", message: "Coupon has expired or is invalid: No coupon applied"}
  end

  render json: @return_obj  


end

def complete_registration

  #get variables
  @event = Event.find_by_slug(params[:slug].to_s) or not_found
  @user = User.where(:id => @event.user_id.to_i).first
  @account = Account.where(:user_id => @user.id.to_s).first 

  #save ticket id, quantity and find ticket price
  ticket_id = params[:ticket]["title"]
  quantity_num =   params[:ticket_quantity][ticket_id]  
  @ticket = Ticket.find((ticket_id).to_i)


  @code = params[:couponCode]

  logger.debug "COUPON CODE iS:: #{@code}"



  #calculate tickets
  sum = 0 
  fee = 0

  #get fee rates
  @fee_rate = @user.npo == true ? 0.015 : 0.025

  sum = @ticket.price.to_f * quantity_num.to_i
  if @ticket.price.to_f != 0
      fee += (@ticket.price.to_f * @fee_rate) * quantity_num.to_i
  end 

  logger.debug "FEE AT TOP: #{fee}"
                        
  fee = (fee * 100).round.to_i

  @final_charge = (sum * 100).to_i #add all line items to figure out final price

  if !@code.blank?
    @coupon = get_coupon(@code, @event.id)


    if @coupon.nil?
      # flash[:error] = 'Coupon code is not valid or expired.'
      # redirect_to slugger_path(@event)
      #return
      #
      @final_amount = @final_charge
    else
      #@discount_amount = @final_charge * @discount
      if @coupon.is_fixed == true
        @final_amount = @final_charge - (@coupon.discount * 100).to_i
        if @final_amount < 0
          flash[:error] = 'Coupon code is not valid or expired.'
          redirect_to slugger_path(@event)
        end
      else
        @discount_amount = @final_charge * (@coupon.discount/100)
  
        @final_amount = @final_charge - @discount_amount.to_i
  
        fee = (fee - (fee * (@coupon.discount/100))).to_i

        logger.debug "FINAL AMOUNT BOUT THAT: #{@final_amount}"

      end


    end
  else
    @final_amount = @final_charge


  end

  if @final_amount > 0
    fee += 99 * quantity_num.to_i
  end

 
  


  logger.debug "FINAL SUM: #{@final_charge}"
  logger.debug "FINAL FEE: #{fee}"


# 10:21:43 web.1  | DISCOUNT RATE iS:: 50.0
# 10:21:43 web.1  | FINAL SUM: 10000
# 10:21:43 web.1  | FINAL FEE: -12201.0
# 10:21:43 web.1  | FINAL CHARGE WITH DISCOUNT: -490000.0


  #Get the credit card details submitted by the form
  token = params[:stripeToken]
  amount = @final_amount

  logger.debug "FINAL CHARGE WITH DISCOUNT: #{amount}"
  
    if amount > 0

      #purchase
      @purchase = Purchase.new
      @purchase.event_id = @event.id.to_s
      @purchase.total_order = amount
      @purchase.total_fee = fee
      @purchase.affiliate_code = params[:ref_code]
      if @purchase.save
      else
      end

 
      if @purchase.update(purchase_params)
        if !@code.blank? && !@coupon.nil?
          charge_metadata = {
            :order_id=> @purchase.id, 
            :purchase_email => @purchase.email,
            :coupon_code => @code,
            :coupon_discount =>  @coupon.is_fixed == true ? '$' + @coupon.discount.to_s :  (@coupon.discount).to_s + "%"
          }
        else
          charge_metadata = {
            :order_id=> @purchase.id, 
            :purchase_email => @purchase.email
          }
        end 

        begin
          charge = Stripe::Charge.create({
            :amount => (amount + fee),
            :currency => @event.currency_type.downcase,
            :source => token,
            :application_fee => fee,
            :metadata => charge_metadata
          }, {:stripe_account => @account.stripe_user_id})
          logger.debug "CHARGE is paid:::: #{charge['paid']}"
          if charge["paid"] == true
            @purchase.stripe_id = charge["id"]
            if @purchase.update(purchase_params)
            else
            end
           #Save customer to the db
           

                  num_tickets = quantity_num.to_i
                  (1..num_tickets).each do |i|
                    @line_item = LineItem.new

                    @line_item.ticket_id = @ticket.id.to_s
                    @line_item.quantity = quantity_num.to_i
                    @line_item.purchase_id = @purchase.id.to_s

                      if @line_item.save    
                      end
                  end

                  #save attendees


                  @line_items = LineItem.where(:purchase_id => @purchase.id.to_s).all
              
                  guest_list = @line_items

                  @line_items.each do |guest_item|

                    @attendee = Attendee.new
                    @attendee.first_name = params[:purchase]['first_name']
                    @attendee.last_name = params[:purchase]['last_name']
                    @attendee.email = params[:purchase]['email']
                    @attendee.user_id = params[:user_id]
                    @attendee.event_id = params[:event_id]
                    logger.debug "GUEST ITEM ID : #{guest_item.id.to_s}"
                    @attendee.line_item_id = guest_item.id.to_s
                    @attendee.attending = true
                      if @attendee.save
                        #save attendee_id to line_items
                        @line_item = guest_item
                        @line_item.attendee_id = @attendee.id

                        line_params = { :attendee_id => @attendee.id}

                          if @line_item.update(line_params)
                          else
                          end

                      else
                      end


                  end
            
            UserMailer.send_tickets(@event, @purchase, @line_items).deliver unless @purchase.invalid?
            render :js => "window.location = '/" + @event.slug + "/confirm" + "?oid=" + @purchase.confirm_token.to_s + "'"  #hack
          else
            logger.debug "CHARGE SHOULD BE FAILED"
            #if error delete what just happened
            @line_items.each do |line_item|
              @attendee_to_delete = Attendee.find(@line_item.attendee_id.to_i)
              @attendee_to_delete.destroy
            end 
            @purchase.destroy

          end 

        rescue Stripe::CardError => e

            logger.debug "CARD DECLINED"
          # The card has been declined

            @purchase.destroy
    
 
        else 
        end
      end


      #render :js => "window.location = '/" + @event.slug + "/confirm" + "?oid=" + @purchase.id.to_s + "'"  #hack
    else



#purchase
      @purchase = Purchase.new
      @purchase.event_id = @event.id.to_s
      @purchase.total_order = amount
      @purchase.affiliate_code = params[:ref_code]

      if @purchase.save
      else
      end
         
      if @purchase.update(purchase_params)

        num_tickets = quantity_num.to_i
        (1..num_tickets).each do |i|
          @line_item = LineItem.new

          @line_item.ticket_id = @ticket.id.to_s
          @line_item.quantity = quantity_num.to_i
          @line_item.purchase_id = @purchase.id.to_s

            if @line_item.save    
            end
        end

                #save attendees


        @line_items = LineItem.where(:purchase_id => @purchase.id.to_s).all
        
        guest_list = @line_items

        @line_items.each do |guest_item|

          @attendee = Attendee.new
          @attendee.first_name = params[:purchase]['first_name']
          @attendee.last_name = params[:purchase]['last_name']
          @attendee.email = params[:purchase]['email']
          @attendee.user_id = params[:user_id]
          @attendee.event_id = params[:event_id]
          @attendee.line_item_id = guest_item.id.to_s
          @attendee.attending = true
            if @attendee.save
              #save attendee_id to line_items
              @line_item = guest_item
              @line_item.attendee_id = @attendee.id

              line_params = { :attendee_id => @attendee.id}

                if @line_item.update(line_params)
                else
                end

            else
            end


        end

      else
        #purchase wasn't updated and didn't go through
      end

########

      UserMailer.send_tickets(@event, @purchase, @line_items).deliver unless @purchase.invalid?
      redirect_to show_confirm_path(:oid => @purchase.confirm_token.to_s)
    end







end

def show_confirm 



  @purchase = Purchase.where(:confirm_token => params[:oid] ) 
  @event = Event.find_by_slug(params[:slug])
  @user = User.find(@event.user_id)

  @event = Event.find_by_slug(params[:slug])
  @eventurl = 'http://'+ ENV['SITE_NAME'] + '/' + @event.slug
  @purchase = Purchase.where(:confirm_token => params[:oid] ).first
  @line_items = LineItem.where(:purchase_id => @purchase.id)

     
end

def select_tickets
  @event = Event.find_by_slug(params[:slug]) or not_found

  @purchase = Purchase.new
  @purchase.event_id = @event.id
  if @purchase.save


    @event.tickets.all.each do |ticket|

      num_tickets = (params[:ticket_quantity][ticket.id.to_s]).to_i
      (1..num_tickets).each do |i| 
        @line_item = LineItem.new
        @quantity = params[:ticket_quantity][ticket.id.to_s]
        ticket_id = params[:ticket_id][ticket.id.to_s]

        @line_item.ticket_id = ticket_id
        @line_item.quantity = @quantity
        @line_item.purchase_id = @purchase.id.to_s

        if @line_item.save


        else
                  
        end
      end
    end

  else

  end





  redirect_to show_buy_path(:oid =>@purchase)
end


def show



    session[:return_to] ||= request.path

    @hash = AmazonSignature::data_hash



     if signed_in?
      @user = current_user
      @account = Account.where(:user_id => @user.id).first.nil? ? nil : Account.where(:user_id => @user.id).first

    else
      @account = nil
    end
    @event = Event.find_by_slug(params[:slug]) or not_found


    @tickets = @event.tickets.all 

    @total = 0

    @coupons = Coupon.where(:event_id => @event.id).all
    logger.debug "@coupons ==== #{@coupons}"

    # @tickets.each do |ticket|
    #   Purchase.where(:event_id => @event.id).all.each do |purchase|
    #     @total += LineItem.where(:purchase_id => purchase.id).count
    #   end

    #   @ticket_quantity_left = ticket.ticket_limit.to_i - @total.to_i
    # end 
    
    @tickets.each do |ticket|
      #if !Purchase.where(:event_id => @event.id).nil?
        Purchase.where(:event_id => @event.id).all.each do |purchase|
          @total += LineItem.where(:purchase_id => purchase.id.to_s).count
        end
      #end

      # if ticket.stop_date.to_date > @event.date_start.to_date
      #   @ticket_stop = ticket.stop_date.to_date > @event.date_start.to_date
      #   @event.html_hero_1['<span class="btn btn-reg open-registration"> Register now</span>'] = '<span class="btn btn-reg">Registration closed</span>'  
      # end

      @ticket_quantity_left = ticket.ticket_limit.to_i - @total.to_i
    end

    # if @ticket_quantity_left < 1
    #   if @ticket_stop
    #     @event.html_hero_1['<span class="btn btn-reg">Registration closed</span>'] = '<span class="btn btn-reg">Sold out</span>'  
    #   else 
    #     @event.html_hero_1['<span class="btn btn-reg open-registration"> Register now</span>'] = '<span class="btn btn-reg">Sold out</span>'
    #   end 
    # end

    

    #<span class="btn btn-reg open-registration"> Register now</span>


    @has_paid_ticket = false
    @tickets.each_with_index do |ticket, index|
      if index == 0
        @current_ticket = ticket
      end 
      if ticket.price.to_i > 0 
       
        @has_paid_ticket = true
      end
    end

    @coupon = Coupon.where(:event_id => @event.id).first.nil? ? Coupon.new : Coupon.where(:event_id => @event.id).first

    @slug = params[:slug]


    @ticket_price = @current_ticket.price.nil? ? 0 :  @current_ticket.price 


    @attendees = Attendee.where(:event_id => @event.id)

    @buyers = Purchase.where(:event_id => @event.id)
    @user = User.find(@event.user_id.to_i)
    @fee_rate = @user.npo == true ? 0.015 : 0.025
    logger.debug "#{@current_ticket.price}"
    @starter_price =  (@current_ticket.price == 0 || @current_ticket.price.nil?) ? 0 : (@current_ticket.price + 0.99) + (@current_ticket.price * @fee_rate)


    #@ticket = @event.tickets.build(ticket_params)
    @ticket = Ticket.new

    @ticket = Ticket.where(:event_id => @event.id).first
    @purchase = Purchase.new

    if !@event

      render_404
    else 

       #@event = Event.where('id' => 70)
      #@event = Event.find(request.subdomain)
      if @event.published == false && !signed_in?
          #&& current_user.id.to_i != @event.user_id.to_i
          redirect_to root_path
      else  
        @user = User.find(@event.user_id)

          image_style_array = ['wedding','concert', 'gala', 'party', 'sport', 'other']
          @attendee = Attendee.new



          client = Bitly.client
          @url = 'http://eventcreate.com' + slugger_path( @event)
          @bitly = client.shorten(@url)  #airplane



          if(!@event.layout_style?)
            @event.layout_id = '1'
            @event.layout_style = 'default'
          end

          respond_with(@attendees, @event)
      end

      @themes = Theme.all

    end
   

  end

  # send contact an email
  def contact_host
    @email = params[:name]
    @message = params[:message]
    @event = Event.find_by_slug(params[:slug])

    UserMailer.contact_host(@email, @message, @event).deliver

    respond_with(@event, :location => slugger_url)

  end

  def update_theme

    @user = User.find(current_user.id)
    @event = Event.find_by_slug(params[:slug])



    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to slugger_path(@event.slug), notice: 'Event was successfully updated.' }
        format.js
        format.json { render :show, status: :ok, location: slugger_path(@event.slug) }
      else

        # "no save"
        #format.html { render :edit }
        #format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end

  end

  def unsplash_search

    @search_results = Unsplash::Photo.search(params[:searchTerm])


    render json: @search_results

  end


  # GET /events/new
  def new


    @themes = Theme.all

    if @disable_create && !@premium_disable
       redirect_to pricing_path
    else 

      @user = User.find(current_user.id)
      @event = Event.all.build
      
    end 

    @themes = Theme.all

  end

  # GET /events/1/edit
  def edit

    @themes = Theme.all

  end

  # POST /events
  # POST /events.json
  # 
  def create

    @themes = Theme.order(:id).all

    @user = User.find(current_user)
    @event = @user.events.build(event_params)
    @event.user_id = current_user.id
    @event.published = true
    @event.layout_id = '1'

    @eventHTML = '<div id="hero">
            <div class="container">
                <div class="header-content">
                  <img src="https://s3-us-west-1.amazonaws.com/eventcreate-v1/uploads%2F1472761845708-logo3.png"/>

                  <h1>' + @event.name + '</h1><p class="lead">Join us on ' + @event.date_start.to_date.strftime("%B %d ") + '<p>

                  <span class="btn btn-reg open-registration"> Register now</span>
                </div> 
              </div>
        </div>'



    @eventBodyHtml = '<div id="about">

        <div class="container about-container">
          <div class="row">
            <div class="col-md-12">
              <h3 class="subheader">/About </h3>
              <p>Tell the attendees about your event! Lorem ipsum dolor sit amet Nullam vel ultricies metus, at tincidunt arcu. Morbi vestibulum, ligula ut efficitur mollis, mi massa accumsan justo, accumsan auctor orci lectus ac ipsum. Proin porta nisl sem, ac suscipit lorem dignissim et. Curabitur euismod nec augue vitae dictum. Nam mattis, massa quis consequat molestie, erat justo vulputate tortor, a sollicitudin turpis felis eget risus. Aliquam viverra urna felis, eu ornare enim consectetur sed. Morbi vitae ultrices velit. Sed molestie consectetur metus. Proin neque eros, dapibus ac accumsansodales sit amet velit. </p>
            </div>

          </div>  
        </div>


        <div class="container-fluid">
          <div class="row">
            <div class="col-md-4 col-sm-padding">
              <img src="https://s3-us-west-1.amazonaws.com/eventcreate-v1/uploads%2F1473442632648-sample1.jpg" class="img-responsive">
            </div>
            <div class="col-md-4 col-sm-padding">
              <img src="https://s3-us-west-1.amazonaws.com/eventcreate-v1/uploads%2F1473442697754-sample2.jpg" class="img-responsive">
            </div>
            <div class="col-md-4 col-sm-padding">
              <img src="https://s3-us-west-1.amazonaws.com/eventcreate-v1/uploads%2F1473443230179-sample3.jpg"class="img-responsive">
            </div>
          </div>  
        </div>
      </div>


      <div id="speakers" class="hidden">

        <div class="container about-container" data-repeatable="speakers">
        <h3 class="subheader"> /Speakers</h3>


        <div class="row repeatable" >
          <div class="col-md-5">
            <img src="https://s3-us-west-1.amazonaws.com/eventcreate-v1/uploads%2F1473455426859-portrait2.jpg" class="img-responsive">
          </div>
          <div class="col-md-7">
            <h1>Jane Smith  </h1>
            <h4>CEO aka The Boss</h4>
            <p>Sed faucibus bibendum efficitur. Aliquam quis imperdiet urna. Sed tincidunt elit quis dolor aliquam sodales. Fusce eu fermentum eros, sit amet porttitor erat. Suspendisse accumsan mollis purus id rhoncus. Vestibulum feugiat ligula ut orci rhoncus efficitur. Phasellus vitae justo eu nisl hendrerit dictum vitae quis sapien.</p>
          </div>
        </div>    


        </div>
      </div>

      <div id="program">
        <div class="container about-container" data-repeatable="program">

          <h3 class="subheader">/Schedule</h3>
          <div class="row repeatable ">
            <div class="col-md-12">
              <h4>5:00PM </h4>
              <h1>Welcome and Happy Hour </h1>
              <p>Sed faucibus bibendum efficitur. Aliquam quis imperdiet urna. Sed tincidunt elit quis dolor aliquam sodales. </p>
            </div>
          </div>  
          <div class="row repeatable ">
            <div class="col-md-12">
              <h4>5:30PM </h4>
              <h1>Presentations </h1>
              <p>Sed faucibus bibendum efficitur. Aliquam quis imperdiet urna. Sed tincidunt elit quis dolor aliquam sodales. </p>
            </div>
          </div>

        </div>
      </div>

      <div id="sponsors" class="hidden">
        <div class="container about-container">
          <h3 class="subheader">/Sponsors</h3>
          <div class="row">
            <div class="col-md-12">
              <img src="https://s3-us-west-1.amazonaws.com/eventcreate-v1/uploads%2F1473456849006-sponsors1.jpg" class="img-responsive" /> 
            </div>
          </div>
        </div>
      </div>'



   

    @eventFooterHTML ='<div id="footer">
        <div class="container">
            Made with <a href="https://www.eventcreate.com/">EventCreate </a>
        </div>
    </div>'



      @event.html_hero_1 = @eventHTML
      @event.html_body_1 = @eventBodyHtml
      @event.html_footer_1 = @eventFooterHTML

      @userEmail = User.find(current_user)
      @total_events = @user.events.count
      logger.debug "TOTAL EVENTS:: #{@total_events}"
      if @total_events == 0
        UserMailer.event_checkin(@userEmail).deliver
      end

    #########


    if Event.where(:user_id => current_user.id.to_s).count >= 0
      str = '?editing=true'
    else
      str = ''
    end


    respond_to do |format|
      if @event.save

          ticket_vars = {title: @event.name, stop_date: @event.date_start.nil? ? nil : @event.date_start , buy_limit: 4, ticket_limit: 1000, price: 0, description: nil  }
          @ticket = @event.tickets.build(ticket_vars)
          # @ticket = Ticket.new
          # @ticket.title = @event.name
          # @ticket.stop_date = @event.date_start
          # @ticket.buy_limit = 4
          # @ticket.ticket_limit = nil
          # @ticket.price = 0
          # @ticket.description = nil

          @ticket.save


        format.html { redirect_to slugger_path(@event) + str, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: event_path(current_user, @event) }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def check_slug

    @event_exists = Event.exists?( slug: params[:slug])

    if @event_exists
      flash[:notice] = 'Task was successfully created.' 
    end
    respond_with(@event)


  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update

    #@user = User.find(params[:user_id])
    @event = Event.find_by_slug(params[:id])
    respond_to do |format|
      if @event.update(event_params)
         #format.html { redirect_to slugger_path(@event.slug), notice: 'Event was successfully updated.' }
         #format.html { redirect_to dashboard_event_path(:event => @event.id) + '#settings', event_success: 'Event details was successfully updated.'}
        format.html { redirect_to slugger_path(@event.slug, :editing => "true"), event_success: 'Event details was successfully updated.'}

         format.js   { render action: 'event-success', status: :created, location: dashboard_event_path(:event => @event.id) }
         format.json { render :show, status: :ok, location: slugger_path(@event.slug) }
      else
        format.html { redirect_to dashboard_event_path(:event => @event.id) + '#settings', notice: 'Event details was NOT updated =(' }

        # # added:
         format.js   { render json: @event.errors, status: :unprocessable_entity }
        format.js { render action: 'event-fail', status: :created, location: dashboard_event_path(:event => @event.id) }
        #  format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end





  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    #@event.destroy
    @event.published = false
    @event.status = false
    respond_to do |format|

      if @event.save

        format.html { redirect_to controller: 'dashboard', action: 'index', notice: 'Event was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  def export_events

     @event = Event.find_by_slug(params[:slug])

     @calendar = Icalendar::Calendar.new
     event = Icalendar::Event.new
    event.dtstart = @event.date_start.to_date.strftime("%Y%m%d") + (@event.time_start.blank? || @event.time_start.nil? ? 'T000000': @event.time_start.to_time.strftime("T%H%M%S") )
     event.dtend = ((!@event.date_end.blank?) ? @event.date_end.to_date.strftime("%Y%m%d"): @event.date_start.to_date.strftime("%Y%m%d") ) + (@event.time_end.nil? || @event.time_end.blank? ? 'T000000': @event.time_end.to_time.strftime("T%H%M%S"))
  
     event.summary = @event.name
     event.description = @event.description
     event.location = @event.location
     @calendar.add_event(event)
     @calendar.publish
     headers['Content-Type'] = "text/calendar; charset=UTF-8"
     render :layout => false, :text => @calendar.to_ical
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      #@user = User.find(params[:user_id])
      @event = Event.find(params[:id])
    end




    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      valid = params.require(:event).permit(:name, :event_time, :date_start, :date_end, :time_start, :time_end, :time_display,:layout_id, :layout_style, :background_img, :show_custom, :slug, :location, :location_name, :description, :published, :host_name, :bg_opacity, :bg_color, :font_type, :external_image, :status, :html_hero_1,:html_hero_button, :html_body_1, :html_footer_1, :html_footer_button, :currency_type, :confirmation_text)


      date_format = '%m/%d/%Y'
      if !valid[:date_start].nil?
        valid[:date_start] = valid[:date_start] != '' ? Date.strptime(valid[:date_start], date_format) : valid[:date_start]
        valid[:date_end] = valid[:date_end] != '' ? Date.strptime(valid[:date_end], date_format): valid[:date_end]
      end

      # if !valid[:name].nil? || !valid[:name].blank?
      #   valid = false
      # end
      return valid
    end

    def purchase_params
      params.require(:purchase).permit( :email, :first_name, :last_name, :phone_number, :oid, :total_order, :total_fee, :affiliate_code, :stripe_id)
    end

    def line_item_params
      params[:line_item]
    end

    def account_params   
      params[:account]
    end

    def ticket_params
      params.require(:ticket).permit(:title, :description, :price, :ticket_limit, :buy_limit, :stop_date)
    end

    def find_subdomain
        logger.debug "#{request.subdomain}"
      #@city_or_state = City.find_by_subdomain(request.subdomain) || State.find_by_subdomain(request.subdomain)
      
        @user = User.find_by subdomain: request.subdomain
        
    end

    def find_site

        # generalise away the potential www. or root variants of the domain name
        # 
        logger.debug "request host with subd: #{request.host}"
        if request.subdomain == 'www'
          req = request.host[4..-1]

        logger.debug "request after cut host with subd: #{req}"
        else

          req = request.host

        end


        # first test if there exists a Site with the requested domain, 
        # then check if it's a subdomain of the application's main domain
        @user = User.find_by(domain: req) || User.find_by(subdomain: request.subdomain)


        # if a matching site wasn't found, redirect the user to the www.<root url>
        redirect_to root_url(subdomain: 'www') unless @user
      end


      def get_coupon(code, eventId)
        # Normalize user input
        code = code.gsub(/\s+/, '')
        code = code.upcase
        @coupon_code = Coupon.where(:promo_code => code, :event_id => eventId).first
      end


  end
