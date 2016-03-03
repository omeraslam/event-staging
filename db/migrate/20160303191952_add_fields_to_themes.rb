class AddFieldsToThemes < ActiveRecord::Migration
  def change
    add_column :themes, :font_type, :string
    add_column :themes, :bg_opacity, :string
    add_column :themes, :bg_color, :string
  end
end
