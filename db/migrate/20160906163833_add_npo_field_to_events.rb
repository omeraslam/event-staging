class AddNpoFieldToEvents < ActiveRecord::Migration
  def change
    add_column :events, :npo, :boolean, default: false
  end
end
