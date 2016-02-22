class Event < ActiveRecord::Base
        #belongs_to :user
        mount_uploader :background_img, PictureUploader
        
        # def format_date
        #    self.date_start.to_date.strftime('%B %d')
        # end

        validates_presence_of :slug, :name
        extend FriendlyId
        friendly_id :slug_candidates, use: :slugged

        def slug_candidates
          [
            :name,
            [:name, :user_id],
            [:name, :id, :user_id]
          ]
        end

       

        # def to_param
        # 	slug
        # end

        require 'icalendar'
        include Icalendar
  
        def to_ics(for_outlook = false)
          cal = Calendar.new
        
          event = Event.new
          event.dtstart ics_start_datetime, {:TZID => self.timezone }
          event.dtend ics_end_datetime, { :TZID => self.timezone }
          event.summary = self.name
        
          event.location = ics_location  
          event.url = ics_url
          event.description = ics_description
        
          cal.add_event(event)
          cal_out = cal.to_ical
          cal_out = cal_out.gsub('VERSION:2.0', '') if for_outlook

          cal_out
        end
        
        def ics_url
          "http://#{HOST_CONSTANT}/projects/#{self.project.to_param}/project_events/#{self.to_param}"
        end
        
        def ics_location
          (self.address1.blank? ? "" : "#{self.address1}, " ) +
            (self.address2.blank? ? "" : "#{self.address2}, ") +
            (self.city.blank? ?  "" : "#{self.city}, " ) +
            (self.state.blank? ? "" : self.state )
        end
        
        def ics_description
          "#{self.short_description}\n\n#{self.long_description}\n\nMore details at #{ics_url}"
        end
        
        def ics_start_datetime
          self.class.ics_datetime(self.utc_start_datetime) # Note: utc_start_datetime should be different than the local time of the event
        end
        
        def ics_end_datetime
          self.class.ics_datetime(self.utc_end_datetime) # Note: utc_end_datetime should be different than the local time of the event
        end
          
        def self.ics_datetime(utc_time_obj)
          time_obj.strftime('%Y%m%dT%H%M%SZ')
        end
end
