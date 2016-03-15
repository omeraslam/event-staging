class CreateJoinTableEventRegistrationsForEventsAndAttendees < ActiveRecord::Migration
  def change
    create_join_table :events, :attendees, table_name: :reservation do |t|
        t.index :attendee_id
        t.index :event_id
    end
  end
end
