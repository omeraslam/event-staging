json.array!(@survey_answers) do |survey_answer|
  json.extract! survey_answer, :id, :answer_text, :attendee_id, :survey_question_id, :event_id
  json.url survey_answer_url(survey_answer, format: :json)
end
