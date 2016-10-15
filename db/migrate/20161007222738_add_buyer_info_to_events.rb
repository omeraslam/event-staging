class AddBuyerInfoToEvents < ActiveRecord::Migration
  def change
    add_column :events, :buyer_only, :boolean, default: true
  end
end
