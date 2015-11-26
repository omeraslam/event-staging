class Event < ActiveRecord::Base
        #belongs_to :user
        mount_uploader :background_img, PictureUploader
        
        # def format_date
        #    self.date_start.to_date.strftime('%B %d')
        # end

        validates_presence_of :slug

       

        def to_param
        	slug
        end
end
