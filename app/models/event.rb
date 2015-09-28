class Event < ActiveRecord::Base
        belongs_to :user
        mount_uploader :background_img, PictureUploader
end
