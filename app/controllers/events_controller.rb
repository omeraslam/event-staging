
class EventsController < ApplicationController
  require "uri"
  require "net/http"

  include ActionView::Helpers::NumberHelper

  
  #before_filter :find_subdomain, only: [ :home]
  before_filter :find_site, only: [:home]
  before_filter :force_http, only: [:show,:complete_registration,:update_theme, :update, :unsplash_search]

  if !Rails.env.development?
    force_ssl except: [:show, :complete_registration, :show_confirm,:update_theme, :update, :unsplash_search]
  end


  before_filter :ensure_proper_subdomain, only: [:checkout_page, :select_buy, :show_buy, :show_confirm, :show_ticket]

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
  before_filter :authenticate_user!, :except => [:show, :export_events, :home, :contact_host, :show_ticket, :select_tickets, :show_buy, :complete_registration, :show_ticket, :show_confirm, :select_buy, :choose_tickets, :submit_attendees, :check_coupon]
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


  #NEW REGISTRATION
  
  # select tickets to buy
  def select_buy


    @event = Event.find_by_slug(params[:slug])


    #@purchase = Purchase.where(:event_id => @event.id, :first_name => nil ).destroy_all

    if(!@event.layout_style?)
      @event.layout_id = '1'
      @event.layout_style = 'default'
    end

    @user = User.where(:id => @event.user_id.to_i).first
    @tickets = @event.tickets.all 

    @tickets_for_purchase = @event.tickets.where(:is_active => true)
    @purchase = Purchase.new
  end

  # submit tickets to buy
  def choose_tickets



   @event = Event.find_by_slug(params[:slug]) or not_found

    logger.debug "TICKET QUANTITY: #{params[:ticket_quantity]}"
    ticket_sum = 0
    params[:ticket_quantity].each do |key, value|
      logger.debug "#{value}"
      ticket_sum += value.to_i
    end

    if ticket_sum == 0

      respond_to do |format|
        format.html { redirect_to select_buy_path, :flash => { :error => 'Please select a ticket' }}
      end
    else 
      @purchase = Purchase.new
      @purchase.event_id = @event.id
      if @purchase.save


        @event.tickets.all.each do |ticket|

          num_tickets = (params[:ticket_quantity][ticket.id.to_s]).to_i
          (1..num_tickets).each do |i| 
            @line_item = LineItem.new
            @quantity = params[:ticket_quantity][ticket.id.to_s]
            ticket_id = params[:ticket_id][ticket.id.to_s]

            @line_item.ticket_id = ticket_id.to_s
            @line_item.quantity = @quantity
            @line_item.purchase_id = @purchase.id.to_s

            if @line_item.save


            else
                      
            end
          end
        end

      else

      end
      logger.debug "REF CODE IS::::: #{params[:ref_code]}"
      if params[:ref_code] != nil
        redirect_to show_buy_path(:oid => @purchase.confirm_token.to_s, :refcode => params[:ref_code])
      else
        redirect_to show_buy_path(:oid => @purchase.confirm_token.to_s)

      end
     
    end
  end

  def submit_attendees

    Stripe.api_key = ENV['STRIPE_SECRET_KEY']


    #replace with actual data


    #get variables
    @event = Event.find_by_slug(params[:slug].to_s) or not_found
    @user = User.where(:id => @event.user_id.to_i).first
    @account = Account.where(:user_id => @user.id.to_s).first 
    @purchase = Purchase.where(:confirm_token => (params[:oid]).to_s).first

    @buyer_only = @event.buyer_only



    @code = params[:couponApplied]


    #calculate tickets
    sum = 0 
    fee = 0


    credit_card_percent = 0.029
    credit_card_cents_fee = 30

      #########

    #get fee rates
    @fee_rate = @user.npo == true ? 0.015 : 0.020
    num_of_paid_tickets = 0


    @survey_questions = @event.survey_questions.where(:is_active => true).all

    logger.debug "SURVEY QUESTION:::: #{@event.survey_questions.count}"
    
    @event.tickets.all.each do |ticket|
      # logger.debug "TICKET IS NIL? #{ticket.id}"
      # logger.debug "PURCHASE ID IS NIL? #{@purchase.id?}"
      #get line item
      @line_items = LineItem.where(:ticket_id => ticket.id.to_s, :purchase_id => @purchase.id.to_s).all

      @line_items.each_with_index do |lineitem, index|

        sum += ticket.price.to_f
        if ticket.price.to_f != 0
            num_of_paid_tickets += 1
            fee += (ticket.price.to_f * @fee_rate)
        end
      end
    end

                   

                          
    fee = (fee * 100).round.to_i


    @final_charge = (sum * 100).to_i #add all line items to figure out final price

    if !@code.blank?
        @coupon = get_coupon(@code, @event.id)


        if @coupon.nil?

          @final_amount = @final_charge
        else
          if @coupon.is_fixed == true
            @final_amount = @final_charge - (@coupon.discount * 100).to_i

            fee =  (@final_amount * @fee_rate).to_i
            if @final_amount < 0
              flash[:error] = 'Coupon code is not valid or expired.'
              #redirect_to slugger_path(@event)
              #redirect to same page
            end
          else
            @discount_amount = @final_charge * (@coupon.discount/100)
      
            @final_amount = @final_charge - @discount_amount.to_i
      
            fee = (fee - (fee * (@coupon.discount/100))).to_i
          end


        end
      else
        @final_amount = @final_charge


      end

      cc_fee = (@final_amount*credit_card_percent) + 30
      logger.debug "fee of just charge: #{cc_fee}"
      logger.debug "@final_amount: #{@final_amount}"
      if @final_charge > 0
        logger.debug "num_of_paid_tickets: #{num_of_paid_tickets}"
        fee += 99 * num_of_paid_tickets
        logger.debug "fee without cc_fee: #{fee}"
        fee += (cc_fee).round.to_i
      end


      logger.debug "@final_charge with discount:  #{@final_amount}"
      logger.debug "FEE WITH CC FEE IS  with discount: #{fee}"


    #Get the credit card details submitted by the form
    token = params[:stripeToken]
    amount = @final_amount

      if amount > 0

        #purchase
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
              :coupon_discount =>  @coupon.is_fixed == true ? '$' + @coupon.discount.to_s :  (@coupon.discount).to_s + "%",
              :slug => @event.slug
            }
          else
            charge_metadata = {
              :order_id=> @purchase.id, 
              :purchase_email => @purchase.email,
              :slug => @event.slug
            }
          end 

          begin
            charge = Stripe::Charge.create({
              :amount => (amount + fee),
              :currency => @event.currency_type.downcase,
              :source => token,
              :application_fee => fee,
              :metadata => charge_metadata,
              :destination => @account.stripe_user_id
            })


            logger.debug "CHARGE is paid:::: #{charge['paid']}"
            if charge["paid"] == true
              @purchase.stripe_id = charge["id"]
              if @purchase.update(purchase_params)
              else
              end
             #Save customer to the db
             
              @array_of_ticket = []
              @buyer_survey_questions = @event.survey_questions.where(:is_active => true, :apply_to_buyer => true).all

                buyer_first_name = params[:purchase]["first_name"]
                buyer_last_name = params[:purchase]["last_name"]
                email = params[:purchase]["email"]

                @purchase.first_name = buyer_first_name
                @purchase.last_name = buyer_last_name
                if @purchase.save

                  @buyer_survey_questions.each_with_index do |buyer_question, index| 
                    #buyeranswer[<%= buyer_question.id %>][index][answer_text]
                    surveyanswer = SurveyAnswer.new

                  if params[:buyeranswer][(buyer_question.id).to_s].nil?
                    surveyanswer.answer_text = 'n/a'
                  else 

                    if buyer_question.field_type == 3 
                      saveAnswer = []
                      buyer_question.answer_text.split(',').each_with_index do |answer, bindex|
                        #logger.debug "#{params[:buyeranswer][(buyer_question.id).to_s][(index).to_s][(bindex.to_s)]["answer_text"]}"
                        if !params[:buyeranswer][(buyer_question.id).to_s][(index).to_s][(bindex.to_s)].nil?
                          saveAnswer.push(answer) 
                        end
                      end

                      surveyanswer.answer_text = saveAnswer.map(&:inspect).join(', ')
                    else 
                      surveyanswer.answer_text =  params[:buyeranswer][(buyer_question.id).to_s][(index).to_s]["answer_text"]
                    end

                  end

                   
                    #surveyanswer.attendee_id = 
                    surveyanswer.event_id = @event.id
                    surveyanswer.survey_question_id = buyer_question.id
                    surveyanswer.purchase_id = @purchase.id 
                    if surveyanswer.save
                    else
                    end



                  end

                end


              @event.tickets.all.each do |ticket|

                @line_items = LineItem.where(:ticket_id => ticket.id.to_s, :purchase_id => @purchase.id.to_s).all


                ##### save survey to buyer
                
                #

                @line_items.each_with_index do |lineitem, index|
                   # create new attendee
                   position = index+1
                  logger.debug "BUYER ONLY::: #{@buyer_only != true}"
                   #if @buyer_only != true 
                     first_name = params[:attendees][(index+1).to_s]["first_name"]
                     last_name = params[:attendees][(index+1).to_s]["last_name"]
                     email = params[:purchase]["email"]
                   # else
                   #   first_name = params[:attendees][(1).to_s]["first_name"]
                   #   last_name = params[:attendees][(1).to_s]["last_name"]
                   #   email = params[:purchase]["email"]
                   # end

                  

                   logger.debug "ATTENDEE INFO: #{first_name}"
                   @attendee = Attendee.new
                   # save first name
                   # save last name
                   @attendee.first_name = first_name
                   @attendee.last_name = last_name
                   @attendee.email = email
                   @attendee.event_id = @event.id
                   @attendee.line_item_id = lineitem.id
                   @attendee.user_id = @user.id
                   @attendee.attending =true

                   # save potential survey questions

                   # save attendee

                   if @attendee.save
                      lineitem.attendee_id = @attendee.id
                       
                      if !params[:surveyanswers].nil?
                          @survey_questions.each_with_index do |survey_question, index|
                         

                            surveyanswer = SurveyAnswer.new
                            if params[:surveyanswers][(lineitem.id).to_s ].nil? || params[:surveyanswers][(lineitem.id).to_s ][(survey_question.id).to_s].nil?
                              surveyanswer.answer_text = 'n/a'
                            else 

                              if survey_question.field_type == 3 
                                saveAnswer = []
                                survey_question.answer_text.split(',').each_with_index do |answer, bindex|
                                  if !params[:surveyanswers][(lineitem.id).to_s ][(survey_question.id).to_s].nil?
                                    saveAnswer.push(answer) 
                                  end
                                end
                                surveyanswer.answer_text = saveAnswer.map(&:inspect).join(', ')
                              else 
                                surveyanswer.answer_text =  params[:surveyanswers][(lineitem.id).to_s][survey_question.id.to_s]["answer_text"]
                              end
                            end

                            surveyanswer.attendee_id = @attendee.id
                            surveyanswer.event_id = @event.id
                            surveyanswer.survey_question_id = survey_question.id
       
                            if surveyanswer.save
                            else
                            end
                        end
                      end

                       if lineitem.save
                       # save attendee id to lineitem
                       @array_of_ticket.push(lineitem)
                       else


                       end

                  end
                end
              end


              
              UserMailer.send_tickets(@event, @purchase, @array_of_ticket).deliver unless @purchase.invalid?
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
          rescue Stripe::StripeError => e
            logger.debug "GENERAL STRIPE ERROR"
            #@purchase.destroy
          rescue Stripe::CardError => e

              logger.debug "CARD DECLINED"
            # The card has been declined

              #@purchase.destroy
      
   
          else 
          end
        end

    else


#############
#
#
  #purchase
        @purchase.event_id = @event.id.to_s
        @purchase.total_order = amount
        @purchase.total_fee = fee
        @purchase.affiliate_code = params[:ref_code]
        if @purchase.save
        else
        end

   
        if @purchase.update(purchase_params)
              
              @array_of_ticket = []


              @buyer_survey_questions = @event.survey_questions.where(:is_active => true, :apply_to_buyer => true).all

                buyer_first_name = params[:purchase]["first_name"]
                buyer_last_name = params[:purchase]["last_name"]
                email = params[:purchase]["email"]

                @purchase.first_name = buyer_first_name
                @purchase.last_name = buyer_last_name
                if @purchase.save

                  @buyer_survey_questions.each_with_index do |buyer_question, index| 
                    #buyeranswer[<%= buyer_question.id %>][index][answer_text]
                    surveyanswer = SurveyAnswer.new
                  
                  if params[:buyeranswer][(buyer_question.id).to_s].nil?
                    surveyanswer.answer_text = 'n/a'
                  else 

                    if buyer_question.field_type == 3 
                      saveAnswer = []
                      buyer_question.answer_text.split(',').each_with_index do |answer, bindex|
                        #logger.debug "#{params[:buyeranswer][(buyer_question.id).to_s][(index).to_s][(bindex.to_s)]["answer_text"]}"
                        if !params[:buyeranswer][(buyer_question.id).to_s][(index).to_s][(bindex.to_s)].nil?
                          saveAnswer.push(answer) 
                        end
                      end

                      surveyanswer.answer_text = saveAnswer.map(&:inspect).join(', ')
                    else 
                      surveyanswer.answer_text =  params[:buyeranswer][(buyer_question.id).to_s][(index).to_s]["answer_text"]
                    end

                  end

                   
                    #surveyanswer.attendee_id = 
                    surveyanswer.event_id = @event.id
                    surveyanswer.survey_question_id = buyer_question.id
                    surveyanswer.purchase_id = @purchase.id 
                    if surveyanswer.save
                    else
                    end



                  end

                end






              @event.tickets.all.each do |ticket|
              

                @line_items = LineItem.where(:ticket_id => ticket.id.to_s, :purchase_id => @purchase.id.to_s).all

                @line_items.each_with_index do |lineitem, index|
                   # create new attendee
                   position = index+1
                 
        

                    first_name = params[:attendees][(index+1).to_s]["first_name"]
                    last_name = params[:attendees][(index+1).to_s]["last_name"]
                    email = params[:purchase]["email"]

           

                   @attendee = Attendee.new
                   # save first name
                   # save last name
                   @attendee.first_name = first_name
                   @attendee.last_name = last_name
                   @attendee.email = email
                   @attendee.event_id = @event.id
                   @attendee.line_item_id = lineitem.id
                   @attendee.user_id = @user.id
                   @attendee.attending =true

                    # save potential survey questions

                    # save attendee

                    if @attendee.save
                      lineitem.attendee_id = @attendee.id

                        if !params[:surveyanswers].nil?
                          @survey_questions.each_with_index do |survey_question, index|
                           
                              surveyanswer = SurveyAnswer.new
                              if params[:surveyanswers][(lineitem.id).to_s ].nil? || params[:surveyanswers][(lineitem.id).to_s ][(survey_question.id).to_s].nil?
                                surveyanswer.answer_text = 'n/a'
                              else 

                                if survey_question.field_type == 3 
                                  saveAnswer = []
                                  survey_question.answer_text.split(',').each_with_index do |answer, bindex|

                                    if !params[:surveyanswers][(lineitem.id).to_s ][(survey_question.id).to_s][bindex.to_s].nil?
                                    #if !params[:surveyanswers][(lineitem.id).to_s ][(survey_question.id).to_s][bindex.to_s].nil?
                                      saveAnswer.push(answer) 
                                    end
                                  end
                                  surveyanswer.answer_text = saveAnswer.map(&:inspect).join(', ')
                                else                    
                                  surveyanswer.answer_text =  params[:surveyanswers][(lineitem.id).to_s][(survey_question.id).to_s]["answer_text"]
                                end
                              end

                              surveyanswer.attendee_id = @attendee.id
                              surveyanswer.event_id = @event.id
                              surveyanswer.survey_question_id = survey_question.id
         
                              if surveyanswer.save
                              else
                              end
                          end
                      end


                      if lineitem.save
                      # save attendee id to lineitem
                      @array_of_ticket.push(lineitem)
                      else
                      end

                    end
                end
              end


                UserMailer.send_tickets(@event, @purchase, @array_of_ticket).deliver unless @purchase.invalid?
                redirect_to show_confirm_path(:oid => @purchase.confirm_token.to_s)
            end

       
        end


  end




  ##### END NEW REGISTRATION



  def finish_registration

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

    #replace with actual data

     @event = Event.find_by_slug(params[:slug])
     @user = User.find(@event.user_id)
     @tickets = Ticket.where(:event_id => @event.id)
     @purchase = Purchase.where(:confirm_token => params[:oid].to_s ).first

    @buyer_only = @event.buyer_only

     @line_items = LineItem.where(:purchase_id => @purchase.id.to_s).all

      ticket_array = @line_items.group(:ticket_id).count
      logger.debug "TICKET ARRAY IS: #{ticket_array}"
     LineItem.count('ticket_id', :distinct => true)

    @user = User.where(:id => @event.user_id.to_i).first
    @account = Account.where(:user_id => @user.id).first 

    @coupons = Coupon.where(:event_id => @event.id).all
     @coupon = Coupon.where(:event_id => @event.id).first.nil? ? Coupon.new : Coupon.where(:event_id => @event.id).first

    @code = params[:couponCode]
    logger.debug "COUPON CODE iS:: #{@code}"

     sum = 0 
     fee = 0


    credit_card_percent = 0.029
    credit_card_cents_fee = 30

      #get fee rates
      @fee_rate = @user.npo == true ? 0.015 : 0.020


    num_of_paid_tickets = 0

    @survey_questions = @event.survey_questions.where(:is_active => true).all
    @buyer_survey_questions = @event.survey_questions.where(:is_active => true, :apply_to_buyer => true).all
    logger.debug "SURVEY QUESTIONS COUNT::: #{@survey_questions.count}"
 
    @event.tickets.all.each do |ticket|

      #get line item
      @line_items = LineItem.where(:ticket_id => ticket.id.to_s, :purchase_id => @purchase.id.to_s).all
      @line_items.each_with_index do |lineitem, index|

        sum += ticket.price.to_f
        if ticket.price.to_f != 0
            num_of_paid_tickets += 1
            fee += (ticket.price.to_f * @fee_rate)
        end
      end
    end

                          
    fee = (fee * 100).round.to_i

    @final_charge = (sum * 100).to_i #add all line items to figure out final price

    logger.debug "SUM GENERAL:: #{sum}"

    cc_fee = (sum*credit_card_percent) + 0.30

    logger.debug "NEW SUM: #{cc_fee}"

      if @final_charge > 0
        logger.debug "num_of_paid_tickets: #{num_of_paid_tickets}"
        fee += 99 * num_of_paid_tickets
        fee += (cc_fee * 100).to_i
      end
      logger.debug "CC FEE = #{cc_fee*100}"
      logger.debug "+ #{99 * num_of_paid_tickets}"

      @final_fee = (fee.to_f/100)


     @line_items = LineItem.where(:purchase_id => @purchase.id.to_s)
     @line_items.each do |line_item|
          @ticket = Ticket.where(:id => line_item.ticket_id.to_i).first
          if !@ticket.nil?
            sum += @ticket.price
          end
     end 
                        

    @final_charge = sum * 100 #add all line items to figure out final price

    if(!@event.layout_style?)
      @event.layout_id = '1'
      @event.layout_style = 'default'
    end


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
      @status = true

    else
      @status = false
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

  credit_card_percent = 0.029
  credit_card_cents_fee = 30
  #get fee rates
  @fee_rate = @user.npo == true ? 0.015 : 0.020

  sum = @ticket.price.to_f * quantity_num.to_i
  if @ticket.price.to_f != 0
      fee += (@ticket.price.to_f * @fee_rate) * quantity_num.to_i
  end 

  logger.debug "FEE AT TOP: #{fee}"
                        
  fee = (fee * 100).round.to_i
  cc_fee = (sum*credit_card_percent) + 0.30


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
        logger.debug "FINAL AMOUNT COUPON #{@final_amount}"
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
    fee += (99 ) * quantity_num.to_i
    fee += (cc_fee * 100).to_i
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


    logger.debug "STRIPE TOKEN IN MODAL CHECKOUT::: #{token}"

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
            :coupon_discount =>  @coupon.is_fixed == true ? '$' + @coupon.discount.to_s :  (@coupon.discount).to_s + "%",
            :slug => @event.slug
          }
        else
          charge_metadata = {
            :order_id=> @purchase.id, 
            :purchase_email => @purchase.email,
            :slug => @event.slug
          }
        end 

          logger.debug "CONNECTED ACCOUNT IS::: #{@account.stripe_user_id}"
        begin
          charge = Stripe::Charge.create({
              :amount => (amount + fee),
              :currency => @event.currency_type.downcase,
              :source => token,
              :application_fee => fee,
              :metadata => charge_metadata,
              :destination => @account.stripe_user_id
            })


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

            logger.debug "SHOW CONFIRM SOMETHING NOT FREE::: #{@purchase.confirm_token.to_s}"
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
        rescue Stripe::StripeError => e
            logger.debug "GENERAL STRIPE ERROR"
            @purchase.destroy

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
      logger.debug "SHOW CONFIRM PATH FREE::: #{@purchase.confirm_token.to_s}"
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

  if(!@event.layout_style?)
    @event.layout_id = '1'
    @event.layout_style = 'default'
  end


     
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


    @scid = ENV['STRIPE_CLIENT_ID']




    if signed_in?
      @user = current_user
      @account = Account.where(:user_id => @user.id).first.nil? ? nil : Account.where(:user_id => @user.id).first
    else
      @account = nil
    end

    @account_exists = nil

    if signed_in? && !@account.nil?
      begin 
        #Stripe.api_key = @account.access_token
        @account_exists = Stripe::Account.retrieve(@account.stripe_user_id)

      rescue Stripe::InvalidRequestError => e
        logger.debug "INVALID REQUEST"
      rescue Stripe::AuthenticationError => e
        logger.debug "AUTHENTICATION REQUEST #{e}"
      rescue Stripe::APIConnectionError => e
        # Network communication with Stripe failed
        logger.debug "APIConnectionError REQUEST #{e}"
      rescue Stripe::StripeError => e
        # Display a very generic error to the user, and maybe 
        logger.debug "GENERIC STRIPE ERROR  REQUEST #{e}"
      end
        logger.debug "ACCOUNT EXISTS:::: #{@account_exists != nil}"
    end 


    if request.domain != ENV['SITE_URL'].to_s
      @event = Event.find_by_domain(request.host) or not_found
    elsif params[:slug].nil?
      @event = Event.find_by_slug(request.subdomain) or not_found
    else
      @event = Event.find_by_slug(params[:slug]) or not_found
    end

    @survey_questions = @event.survey_questions.all

    @tickets = @event.tickets.all 
    @tickets_for_event = []
 
     @survey_question = SurveyQuestion.new
 
     @tickets.each do |ticket|
       tickets_sold = ticket.ticket_limit.to_i - LineItem.where(:ticket_id => ticket.id.to_s).count
       #ticket["description"] = tickets_sold.to_s + " out of " + ticket.ticket_limit.to_s
       ticketobj = ticket
       
       @tickets_for_event.push(ticketobj)
     end

     @current_event_ticket = @tickets_for_event[0]['ticket_object']


    @tickets_for_purchase = @event.tickets.where(:is_active => true)

    @total = 0

    @coupons = Coupon.where(:event_id => @event.id).all
    @current_coupon = Coupon.where(:event_id => @event.id).first

    # @tickets.each do |ticket|
    #   Purchase.where(:event_id => @event.id).all.each do |purchase|
    #     @total += LineItem.where(:purchase_id => purchase.id).count
    #   end

    #   @ticket_quantity_left = ticket.ticket_limit.to_i - @total.to_i
    # end 
    # 
    @total_revenue = 0
    spots_left = 0

        Purchase.where(:event_id => @event.id ).all.each do |purchase|
          @total_revenue += purchase.total_order.nil? || purchase.total_order == 'n/a' ? 0 : purchase.total_order 
          @total += LineItem.where(:purchase_id => purchase.id.to_s).count
        end
    
    @tickets.each do |ticket|
      spots_left += ticket.ticket_limit
 

      
    end
    @ticket_quantity_left = spots_left.to_i - @total.to_i

      registration_count_array = []
      @data_stats = []
      (@event.created_at.to_date..@event.date_start.to_date).each do |date|
        ticket_count = Attendee.where(:event_id => @event.id, :created_at => date.midnight..date.end_of_day).count
        data = {'date' => date, 'registrations' => ticket_count}
        registration_count_array.push(ticket_count)
        @data_stats.push(data)

      end

      guest_count = Attendee.where(:event_id => @event.id).count


      @event_stats = {
        total_revenue: @total_revenue/100,
        registration_data: registration_count_array,
        spots_left: spots_left-guest_count,
        guest_number: guest_count
      }

      # tickets sold
      # if the registration close date on those tickets are closed
      # if the event has already passed
      # draft

      if spots_left-guest_count > 0
        @registration_open = true
      else
        @registration_open = false
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
      if @current_ticket.nil? && ticket.is_active == true
        @current_ticket = ticket
      end 
      if ticket.price.to_i > 0 
       
        @has_paid_ticket = true
      end
    end

    @active_survey_questions = @event.survey_questions.where(:is_active => true).all

    @has_active_questions = @active_survey_questions.count > 0

    @coupon = Coupon.where(:event_id => @event.id).first.nil? ? Coupon.new : Coupon.where(:event_id => @event.id).first

    @slug = params[:slug]


    @ticket_price = @current_ticket.price.nil? ? 0 :  @current_ticket.price 

       @attendee_headers = ["First Name", "Last Name", "Email Address", "Registration Date", "Ticket Type"]
       @buyers_headers = ["First Name", "Last Name", "Email Address", "Guest Count", "Total Order", "Affiliate Code"]
 

 
       survey_headers = []
       @survey_questions = @event.survey_questions.all
       @survey_questions.each do |survey|
         @attendee_headers.push(survey.question_text)
         if survey.apply_to_buyer == true && survey.is_active == true
             @buyers_headers.push(survey.question_text)
         end
       end
 
       @attendees_list = {
         "items" => [],
         "event" => {
           "event_id" => @event.id
           }
       }
 
     

    @attendees = Attendee.where(:event_id => @event.id)

    @attendees.each_with_index do |attendee|
      @guest = LineItem.where(:id => attendee.line_item_id.to_i).first
      @ticket = @guest.nil? ? nil : Ticket.find_by_id( @guest.ticket_id.to_i)
      attendee_block = {
          "id" => attendee.id,
          "first_name" => attendee.first_name,
          "last_name" => attendee.last_name,
          "email" => attendee.email,
          "created_at" => attendee.created_at.to_date.strftime("%B %d, %Y "),
          "ticket_type" => @ticket.nil? ? 'n/a' : '"'+@ticket.title+'"'
        }
        @survey_questions.each_with_index do |survey, index|

          attendee_block[("question_"+(survey.id.to_s))] = ""
        end

        @survey_answers = SurveyAnswer.where(:attendee_id => attendee.id).all


        if @survey_answers.count > 0
          @survey_answers.each_with_index do |sanswer, index|
            attendee_block[("question_"+(sanswer.survey_question_id.nil? ? '0': sanswer.survey_question_id.to_s) )] = sanswer.answer_text
          end
        end

        @attendees_list["items"].push(attendee_block)

    end

    @current_survey_question = @survey_questions.first


    @ticket = Ticket.new

    @ticket = Ticket.where(:event_id => @event.id).first
    @purchase = Purchase.new
    if signed_in? && current_user.id.to_s == @event.user_id.to_s 
      Purchase.where(:event_id => @event.id, :stripe_id => nil).destroy_all
    end
    @buyers = Purchase.where(:event_id => @event.id)
    @buyers_list = {
      "items" => [],
      "event" => {
          "event_id" => @event.id
          }

    }


    @buyers.each do |buyer|
      # @guest = LineItem.where(:id => attendee.line_item_id.to_i).first
      # @ticket = @guest.nil? ? nil : Ticket.find_by_id( @guest.ticket_id.to_i)
      buyer_block = {
          "id" => buyer.id,
          "first_name" => buyer.first_name,
          "last_name" => buyer.last_name,
          "email" => buyer.email,
          "guest_count" => LineItem.where(:purchase_id => buyer.id.to_s).count > 0 ? (LineItem.where(:purchase_id => buyer.id.to_s).count).to_i - 1 : 0,

          "total_order" => buyer.total_order.nil? || buyer.total_order == 'n/a' ? 'n/a' : '$' + ("%.2f" % (buyer.total_order/100)).to_s,
          "affiliate_code" => buyer.affiliate_code == 'null' ? 'n/a' : buyer.affiliate_code
        }
        if !@survey_questions.nil?
          @survey_questions.each_with_index do |survey, index|

            buyer_block[("question_"+(survey.id.to_s))] = ""
          end
        end

        @survey_answers = SurveyAnswer.where(:purchase_id => buyer.id).all


        if !@survey_answers.nil? && @survey_answers.count > 0
          @survey_answers.each_with_index do |sanswer, index|
            buyer_block[("question_"+(sanswer.survey_question_id.nil? ? '0': sanswer.survey_question_id.to_s) )] = sanswer.answer_text
          end
        end

         @buyers_list["items"].push(buyer_block)



   end


    credit_card_percent = 0.029
    credit_card_cents_fee = 30

    @user = User.find(@event.user_id.to_i)

    @fee_rate = @user.npo == true ? 0.015 : 0.020
    logger.debug "#{@current_ticket.price}"
    @starter_price =  (@current_ticket.price == 0 || @current_ticket.price.nil?) ? 0 : (@current_ticket.price + (0.99)) + (@current_ticket.price * @fee_rate)


    #@ticket = @event.tickets.build(ticket_params)

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

          ticket_vars = {title: 'General Admission', stop_date: @event.date_start.nil? ? nil : @event.date_start , buy_limit: 4, ticket_limit: 1000, price: 0, description: nil  }
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
    @event = Event.find(params[:id])
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


      def ensure_proper_subdomain
          puts "ENV SITE URL IS::: #{ENV['SITE_URL']}"
          puts "REQUEST HOST IS::: #{request.host}"
         if request.host != 'checkout.' + ENV['SITE_URL'].to_s
           redirect_to params.merge({host: 'checkout.' + ENV['SITE_URL'].to_s})
         end
      end

      def force_http
        if request.ssl? && Rails.env.production?

          redirect_to params.merge({:protocol => 'http://', :status => :moved_permanently})
        end
      end

  end
