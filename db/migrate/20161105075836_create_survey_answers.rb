class CreateSurveyAnswers < ActiveRecord::Migration
  def change
    create_table :survey_answers do |t|
      t.string :answer_text
      t.integer :attendee_id
      t.integer :survey_question_id
      t.integer :event_id

      t.timestamps
    end
  end
end


