class AddColumnsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :reg_limit, :integer, :default => 50
    add_column :events, :published, :boolean, :default => false
  end
end
