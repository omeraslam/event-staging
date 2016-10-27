class CreateSurveyQuestions < ActiveRecord::Migration
  def change
    create_table :survey_questions do |t|
      t.text :question_text
      t.boolean :response_required
      t.text :description
      t.text :answer_text
      t.integer :field_type
      t.integer :ticket_id
      t.integer :event_id
      t.boolean :is_active
      t.boolean :free_text_active
      t.text :free_text

      t.timestamps
    end
  end
end
