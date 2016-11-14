class AddPurchaseIdToSureyAnswer < ActiveRecord::Migration
  def change
    add_column :survey_answers, :purchase_id, :integer
  end
end
