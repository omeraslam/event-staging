class AddIconToThemes < ActiveRecord::Migration
  def change
    add_column :themes, :icon, :string
  end
end
