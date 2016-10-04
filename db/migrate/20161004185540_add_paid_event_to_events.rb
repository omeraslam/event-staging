class AddPaidEventToEvents < ActiveRecord::Migration
  def change
    add_column :events, :paid_event, :boolean, default: false
  end
end
