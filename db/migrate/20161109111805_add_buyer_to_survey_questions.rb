class AddBuyerToSurveyQuestions < ActiveRecord::Migration
  def change
    add_column :survey_questions, :apply_to_buyer, :boolean, :default => false
  end
end
