class AddEventRefToPurchases < ActiveRecord::Migration
  def change
    add_reference :purchases, :event, index: true
  end
end
