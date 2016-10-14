class AddDomainsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :domain, :string
  end
end
