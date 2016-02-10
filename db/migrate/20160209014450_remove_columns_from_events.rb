class RemoveColumnsFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :style_id, :string
    remove_column :events, :location_display, :boolean
    remove_column :events, :time_display, :boolean
  end
end
