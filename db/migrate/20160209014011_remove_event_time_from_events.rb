class RemoveEventTimeFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :event_time, :datetime
  end
end
