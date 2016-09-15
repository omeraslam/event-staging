class LineItem < ActiveRecord::Base
    has_one :attendee, dependent: :destroy
    before_destroy :destroy_attendees

    private
        def destroy_attendees
            Attendee.where(:line_item_id => "#{id}").destroy_all
        end
end
