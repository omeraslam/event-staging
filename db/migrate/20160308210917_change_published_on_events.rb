class ChangePublishedOnEvents < ActiveRecord::Migration
  def change
    change_column :events, :published, :boolean, :default => false
  end
end
