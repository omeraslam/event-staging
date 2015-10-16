class ChangeUsers < ActiveRecord::Migration
  def up
    change_column :users, :premium, :boolean, :default => false
  end
end
