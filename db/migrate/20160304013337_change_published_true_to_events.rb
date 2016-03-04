class ChangePublishedTrueToEvents < ActiveRecord::Migration
  def change  
    change_column :events, :published, :boolean, :default => true
  end
end
