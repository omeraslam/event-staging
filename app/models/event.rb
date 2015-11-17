class Event < ActiveRecord::Base
        belongs_to :user
        mount_uploader :background_img, PictureUploader
        
        # def format_date
        #    self.date_start.to_date.strftime('%B %d')
        # end

end
