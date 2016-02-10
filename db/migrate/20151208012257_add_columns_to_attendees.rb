class AddColumnsToAttendees < ActiveRecord::Migration
    def change
        add_column :attendees, :attending, :boolean
        add_column :attendees, :event_id, :integer
        add_column :attendees, :user_id, :string
    end
end

