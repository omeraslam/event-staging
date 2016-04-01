class AddDefaultToTickets < ActiveRecord::Migration
  def change
    change_column :tickets, :buy_limit, :integer, :default => 4
  end
end
