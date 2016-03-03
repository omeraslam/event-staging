class AddItemsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :bg_opacity, :string
    add_column :events, :bg_color, :string
    add_column :events, :font_type, :string
  end
end
