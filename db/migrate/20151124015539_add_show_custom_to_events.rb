class AddShowCustomToEvents < ActiveRecord::Migration
  def change
    add_column :events, :show_custom, :boolean
  end
end
