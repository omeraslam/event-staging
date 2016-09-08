class RemoveNpoColumnFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :npo, :boolean
  end
end
