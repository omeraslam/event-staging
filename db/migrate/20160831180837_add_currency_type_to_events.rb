class AddCurrencyTypeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :currency_type, :string, default: "USD"
  end
end
