class AttendeesController < ApplicationController
  before_action :set_attendee, only: [:show, :edit, :update, :destroy]

  respond_to :html, :js 

  def index

    @attendees = Attendee.all
     @attendees = Attendee.where(user_id:current_user.id.to_s, event_id:params[:event])
     @event = Event.find_by id: params[:event]
     #User.where(name: 'David', occupation: 'Code Artist').order(created_at: :desc)
    respond_with(@attendees, @event)
  end

  def show

    respond_with(@attendee)
  end

  def new
    if Attendee.where("user_id = :user_id AND email = :email",
      {user_id: Event.where('slug' => :slug).user_id.to_s, email: params[:email]}).present?
      flash[:notice] = 'Attendee already added'
      redirect_to check_in_path
    else 
      @attendee = Attendee.new
      @attendee.event_id = Event.find_by id: params[:event_id]
    end
    respond_with(@attendee)
  end

  def edit
  end

  def send_preview

    @current_user = current_user
    @attendee_user_id = current_user.id
    @event = Event.find_by id: params[:event_id]
    @event_type = params[:event_type].nil? ? '1' : params[:event_type]

    @event_url = 'https://eventcreate.com/' +  @event.slug

      if @event_type == '1'
        UserMailer.guest_invitation_sent(current_user, current_user, @event, @event_url).deliver unless @current_user.invalid?
      else
        UserMailer.guest_save_date_sent(current_user, current_user, @event, @event_url).deliver unless @current_user.invalid?
      end

      ## on success flash a notice message that it's been sent, js.erb file
      flash[:notice] = 'Preview email sent' 
      redirect_to dashboard_event_path(:event => @event.id)
      ## replace this, instead of page refresh
  end


  def batch_invite

    @event = Event.find_by id: params[:event_id]
    
    guest_list = params[:attendees]

    @event_type = '1'

    @event_url = 'http://eventcreate.com/' +  @event.slug

    @host = User.find_by id: @event.user_id.to_i

    guest_list.each do |guest_item|
        @attendee = Attendee.new
        @attendee.first_name = guest_item[1]["first_name"]
        @attendee.last_name = guest_item[1]["last_name"]
        @attendee.email = guest_item[1]["email_address"]
        @attendee.user_id = params[:user_id]
        @attendee.event_id = params[:event_id]
        @attendee.attending = ''
      

        if Attendee.where("user_id = :user_id AND email = :email",
          {user_id: @attendee.user_id.to_s, email: @attendee.email}).present?


          #user already exists error message


          # ...
        elsif @host.email == @attendee.email

          #email to be added is == to contact host

        else

            if @attendee.save

              if @attendee.id.to_s != @event.user_id.to_s
                  #send guest rsvpd emails
                  if @event_type == '1'
                    UserMailer.guest_invitation_sent(current_user, @attendee, @event, @event_url).deliver unless @attendee.invalid?
                  else
                    UserMailer.guest_save_date_sent(current_user, @attendee, @event, @event_url).deliver unless @attendee.invalid?
                  end
              else
                   #send invitations sent emails
                   #UserMailer.invitation_sent(current_user,@attendee, @event, @event_url).deliver unless @attendee.invalid?
              end


            else

            end
        end


    end

    respond_to do |format|
      #format.html { redirect_to dashboard_event_path(:event => @event.id) + '#invites', notice: 'Invitations sent' }
      format.js   { render action: 'invitation-sent', status: :created, location: dashboard_event_path(:event => @event.id) + '#invites' }    
    end

  end
      
      







  def invite

    @emails = attendee_params[:email].gsub(/\s+/, "")
    @invalid_addresses = []
    @valid_addresses = []

    @emails.split(",").each do |address|
      if valid_email?(address, params[:event_id])
        @valid_addresses.push(address)
      else 
        @invalid_addresses.push(address)
      end
    end

    # @attendee = Attendee.new(attendee_params)
     @current_user = User.find(params[:user_id])
     @attendee_user_id = params[:user_id]
     @event = Event.find_by id: params[:event_id]
     @event_type = params[:event_type].nil? ? '1' : params[:event_type]

      @event_url = 'http://eventcreate.com/' +  @event.slug

      @valid_addresses.each do |attendee_address|
        @attendee = Attendee.new
        @attendee.email = attendee_address
        @attendee.user_id = @attendee_user_id
        @attendee.event_id = @event.id.to_s
        @attendee.attending = false
          if @attendee.save

            if @attendee.id.to_s != @event.user_id.to_s
              #send guest rsvpd emails
              if @event_type == '1'
                UserMailer.guest_invitation_sent(current_user, @attendee, @event, @event_url).deliver unless @attendee.invalid?
              else
                UserMailer.guest_save_date_sent(current_user, @attendee, @event, @event_url).deliver unless @attendee.invalid?
              end
            else
               #send invitations sent emails
               #UserMailer.invitation_sent(current_user,@attendee, @event, @event_url).deliver unless @attendee.invalid?
            end
          else

          end

      end

      respond_to do |format|
          format.html { redirect_to dashboard_event_path(:event => @event.id) + '#invites' }
      end

  end

  def send_invite
      @attendees = Attendee.where(user_id:current_user.id.to_s, event_id:params[:event_id])



      @attendee_user_id = params[:user_id]
      @event = Event.find_by id: params[:event_id]
      @event_type = params[:event_type2].nil? ? '1' : params[:event_type2]


      @attendees.each do |attendee|

        @event_url = 'http://eventcreate.com/' +  @event.slug + '?invited=true&amp;uid='+ attendee.id.to_s

        if attendee.id.to_s != @event.user_id.to_s
          #send guest rsvpd emails
          if @event_type == '1'
            UserMailer.guest_invitation_sent(current_user, attendee, @event, @event_url).deliver unless attendee.invalid?
          else
            UserMailer.guest_save_date_sent(current_user, attendee, @event, @event_url).deliver unless attendee.invalid?
          end
        else
           #send invitations sent emails
           #UserMailer.invitation_sent(current_user,@attendee, @event, @event_url).deliver unless @attendee.invalid?
        end


      end

      redirect_to dashboard_event_path(:event => @event.id) + '#invites'
  end

  def reply

    @attendee = Attendee.find(params[:id])
     @attendee.attending = true
     @attendee.update(attendee_params)

   
  end



  def create
    @attendee_user_id = params[:attendee_user_id]
    attendee_param = params[:attendee]

    @current_user = User.find(params[:user_id])
    @event = Event.find_by id: params[:event_id]

    @event_url = 'http://eventcreate.com/' +  @event.slug


    client = Bitly.client
    @url = 'http://eventcreate.com' + slugger_path(@event)
    @bitly = client.shorten(@url)



    if !@attendee_user_id.blank?
      @attendee = Attendee.find(params[:attendee_user_id])


      @attendee.update(attendee_params)

    elsif Attendee.exists?( email: attendee_param['email'])


      @attendee = Attendee.find_by email: attendee_param['email']
    
      attendee_param['first_name'] =  !@attendee.first_name.blank? ? attendee_param['first_name'] : @attendee.first_name

      attendee_param['last_name'] =  !@attendee.last_name.blank? ? attendee_param['last_name'] :  @attendee.last_name

      @attendee.attending = true
      

      @attendee.user_id = params[:user_id]
      @attendee.event_id =  @event.id.to_s



      respond_to do |format|
        if @attendee.update(attendee_params)
          #if not equal to host
           if @attendee.id.to_s != @event.user_id.to_s
             #send guest rsvpd emails
             UserMailer.welcome_attendee(@attendee, @event_url).deliver unless @attendee.invalid?
             UserMailer.rsvp_update(@current_user, @attendee, @event_url).deliver unless @attendee.invalid?
           else
             #send invitations sent emails
             #UserMailer.invitation_sent(current_user,@attendee, @event, @event_url).deliver unless @attendee.invalid?
             #UserMailer.guest_invitation_sent(current_user, @attendee, @event, @event_url).deliver unless @attendee.invalid?
           end
          
          format.html { redirect_to slugger_path(:slug => @event.slug), notice: 'Person was successfully created.' }
          format.js   { render action: 'confirmation', status: :created, location: slugger_path(:slug => @event.slug) }
          format.json { render :show, status: :created, location: :back }
          #send invite email to them now, thank you and sign up with hash
          #
        else
          format.html { render :new }
          format.json { render json: @attendee.errors, status: :unprocessable_entity }
        end
      end

      
    else
      @attendee = Attendee.new(attendee_params)
      @current_user = User.find(params[:user_id])
      @attendee.user_id = params[:user_id]
      @event = Event.find_by id: params[:event_id]

      @attendee.event_id =  @event.id.to_s
      @event_url = 'http://eventcreate.com/' +  @event.slug


      client = Bitly.client
      @url = 'http://eventcreate.com' + slugger_path(@event)
      @bitly = client.shorten(@url)

      @attendee.attending = true
      #@attendee.save

      respond_to do |format|
        if @attendee.save
          #if not equal to host
           if @attendee.id.to_s != @event.user_id.to_s
             #send guest rsvpd emails
             UserMailer.welcome_attendee(@attendee, @event_url).deliver unless @attendee.invalid?
             UserMailer.rsvp_update(@current_user, @attendee, @event_url).deliver unless @attendee.invalid?
           else
             #send invitations sent emails
             #UserMailer.invitation_sent(current_user,@attendee, @event, @event_url).deliver unless @attendee.invalid?
             #UserMailer.guest_invitation_sent(current_user, @attendee, @event, @event_url).deliver unless @attendee.invalid?
           end
          
          format.html { redirect_to slugger_path(:slug => @event.slug), notice: 'Person was successfully created.' }
          format.js   { render action: 'confirmation', status: :created, location: slugger_path(:slug => @event.slug) }
          format.json { render :show, status: :created, location: :back }
          #send invite email to them now, thank you and sign up with hash
          #
        else
          format.html { render :new }
          format.json { render json: @attendee.errors, status: :unprocessable_entity }
        end
      end
    end
    # redirect_to event_path(:id => @event.id)
    #   respond_with(@attendee)

  end

  def update
    @attendee.update(attendee_params)
    respond_with(@attendee)
  end

  def destroy
    @attendee.destroy
    redirect_to :back
    #respond_with(@attendee)
  end

  private
    def set_attendee
      @attendee = Attendee.find(params[:id])
    end

    def attendee_params
      params.require(:attendee).permit(:attending, :email, :first_name, :last_name, :line_item_id)
      #params.require(:attendee).permit(:first_name, :last_name, :email, :phone_number, :message, :attending)
    end

    def valid_email?(email, event_id)
      email_valid_check = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      email.present? &&
       (email =~ email_valid_check) &&
       Attendee.find_by(email: email, event_id: event_id).nil?
    end

end
