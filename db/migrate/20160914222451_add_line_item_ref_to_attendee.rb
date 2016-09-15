class AddLineItemRefToAttendee < ActiveRecord::Migration
  def change
    add_reference :attendees, :line_item, index: true
  end
end
