class AddColumnsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :reg_limit, :number, :default => 50
    add_column :events, :published, :boolean, :default => false
  end
end
