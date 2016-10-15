class AddGaCodeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ga_code, :string
  end
end
