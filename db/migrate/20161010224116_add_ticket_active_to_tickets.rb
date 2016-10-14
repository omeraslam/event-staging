class AddTicketActiveToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :is_active, :boolean, default: true
  end
end
