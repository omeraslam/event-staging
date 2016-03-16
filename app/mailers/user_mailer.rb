class UserMailer < ActionMailer::Base
  include Devise::Mailers::Helpers
  default from: "EventCreate Team <hello@eventcreate.com>"

    def welcome_email(user)
        @user = user
        @url = 'https://eventcreate.com/create'
        mail(to: @user.email, subject: 'Welcome to EventCreate')
    end

    def reset_password_instructions(record, token, opts={})
      @token = token
      devise_mail(record, :reset_password_instructions, opts)
    end

    def welcome_attendee(attendee, eventurl)
        @attendee = attendee
        @url = eventurl
        mail(to: @attendee.email, subject: 'Your RSVP has been confirmed')
    end

    def invitation_sent(attendee)
        @user = user
        @url = ''
        mail(to: @user.email, subject: 'Your invitation has been sent')
    end

    def contact_host(user_email, message, event)
        @user_email = user_email
        @event = event
        @message = message
        mail(to: @user_email, subject: 'You have a message from your guest')
    end

    def rsvp_update(user, attendee, eventurl)
        @user = user
        @response = (attendee.attending)? 'yes' : 'no'
        @attendee = attendee
        @url = eventurl
        mail(to: @user.email, subject: 'You’ve got RSVP incoming!')
    end

    def guest_invitation_sent(user, attendee, event, eventurl)
       
        @user = user
        @attendee = attendee
        @event = event
        @url = eventurl
        mail(to: @attendee.email, subject: "You've been invited!")
    end

    def guest_save_date_sent(user, attendee, event, eventurl)
        @user = user
        @attendee = attendee
        @event = event
        @url = eventurl
        mail(to: @attendee.email, subject: "Save The Date!")
    end


    def invitation_sent(user, attendee, event, eventurl)
        @user = user
        @attendee = attendee
        @event = event
        @url = eventurl
        mail(to: @user.email, subject: "Your invitation has been sent")
    end

  
end
