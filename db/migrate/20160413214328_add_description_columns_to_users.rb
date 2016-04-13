class AddDescriptionColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :description, :text
    add_column :users, :profile_img, :string
    add_column :users, :header_img, :string
  end
end
