json.array!(@survey_questions) do |survey_question|
  json.extract! survey_question, :id, :question_text, :response_required, :description, :field_type, :ticket_id, :event_id, :is_active, :free_text_active, :free_text
  json.url survey_question_url(survey_question, format: :json)
end
