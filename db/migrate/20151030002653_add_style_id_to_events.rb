class AddStyleIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :style_id, :string
  end
end
