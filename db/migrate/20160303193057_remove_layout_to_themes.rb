class RemoveLayoutToThemes < ActiveRecord::Migration
  def change
    remove_column :themes, :layout, :string
    add_column :themes, :layout_type, :string
  end
end
