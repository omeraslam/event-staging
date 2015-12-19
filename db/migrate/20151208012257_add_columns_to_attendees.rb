class AddColumnsToAttendees < ActiveRecord::Migration
    def change
        create_table :attendees do |t|
            t.string :first_name
            t.string :last_name
            t.string :email
            t.string :phone_number
            t.string :message
            t.boolean :attending
            t.integer :event_id
            t.string :user_id

            t.timestamps
        end
    end
end

