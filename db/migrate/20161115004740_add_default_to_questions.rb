class AddDefaultToQuestions < ActiveRecord::Migration
  def change
    change_column :survey_questions, :response_required, :boolean, :default => false
  end
end
