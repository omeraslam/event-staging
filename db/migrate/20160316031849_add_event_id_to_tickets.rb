class AddEventIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :event_id, :string
  end
end
