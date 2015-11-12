class AddStyleDetailsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :layout_id, :string
    add_column :events, :layout_style, :string
  end
end
