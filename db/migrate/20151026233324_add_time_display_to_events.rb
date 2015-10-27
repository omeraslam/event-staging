class AddTimeDisplayToEvents < ActiveRecord::Migration
  def change
    add_column :events, :time_display, :boolean
  end
end
