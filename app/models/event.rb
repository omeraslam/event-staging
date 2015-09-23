class Event < ActiveRecord::Base
        mount_uploader :background_img, PictureUploader
end
