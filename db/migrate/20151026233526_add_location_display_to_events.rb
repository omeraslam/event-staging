class AddLocationDisplayToEvents < ActiveRecord::Migration
  def change
    add_column :events, :location_display, :boolean
  end
end
