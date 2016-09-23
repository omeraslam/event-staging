class AddColumnToEvent < ActiveRecord::Migration
  def change
    add_column :events, :confirmation_text, :text
  end
end
