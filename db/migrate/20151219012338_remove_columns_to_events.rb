class RemoveColumnsToEvents < ActiveRecord::Migration
  def change
    remove_column :events, :reg_limit, :number
  end
end
