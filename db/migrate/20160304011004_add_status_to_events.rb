class AddStatusToEvents < ActiveRecord::Migration
  def change
    add_column :events, :status, :boolean, :default => true
  end
end
