class AddTimeDetailsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :date_start, :string
    add_column :events, :time_start, :string
    add_column :events, :date_end, :string
    add_column :events, :time_end, :string
  end
end
