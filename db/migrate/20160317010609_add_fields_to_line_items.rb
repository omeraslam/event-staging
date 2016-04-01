class AddFieldsToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :quantity, :integer
    add_column :line_items, :ticket_id, :string
    add_column :line_items, :attendee_id, :string
  end
end
