class ChangeStopDateOnTickets < ActiveRecord::Migration
  def change
    change_column :tickets, :stop_date, :date
  end
end
