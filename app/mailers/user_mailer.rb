class UserMailer < ActionMailer::Base
  default from: "from@example.com"

    def welcome_email(user)
        @user = user
        @url = 'http://eventcreate-v1.herokuapp.com/event-create'
        mail(to: @user.email, subject: 'Welcome to EventCreate')
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
        mail(to: @user.email, subject: "You've been invited!")
    end
    def invitation_sent(user, attendee, event, eventurl)
        @user = user
        @attendee = attendee
        @event = event
        @url = eventurl
        mail(to: @user.email, subject: "Your invitation has been sent")
    end
end
