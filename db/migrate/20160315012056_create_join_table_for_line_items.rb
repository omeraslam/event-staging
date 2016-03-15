class CreateJoinTableForLineItems < ActiveRecord::Migration
  def change
    create_join_table :tickets, :attendees, table_name: :line_item do |t|
      t.index :ticket_id
      t.index :attendee_id 
    end
  end
end
