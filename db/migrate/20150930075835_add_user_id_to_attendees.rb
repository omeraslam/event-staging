class AddUserIdToAttendees < ActiveRecord::Migration
  def change
    add_column :attendees, :user_id, :string
  end
end
