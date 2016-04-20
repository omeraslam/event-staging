class AddSocialToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fb_link, :string
    add_column :users, :tw_link, :string
  end
end
