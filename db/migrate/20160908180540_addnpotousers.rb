class Addnpotousers < ActiveRecord::Migration
  def change
    add_column :users, :npo, :boolean, default: false
  end
end
