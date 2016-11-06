require 'test_helper'

class SurveyQuestionsControllerTest < ActionController::TestCase
  setup do
    @survey_question = survey_questions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:survey_questions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create survey_question" do
    assert_difference('SurveyQuestion.count') do
      post :create, survey_question: { answer_text: @survey_question.answer_text, description: @survey_question.description, event_id: @survey_question.event_id, field_type: @survey_question.field_type, free_text: @survey_question.free_text, free_text_active: @survey_question.free_text_active, is_active: @survey_question.is_active, question_text: @survey_question.question_text, response_required: @survey_question.response_required, ticket_id: @survey_question.ticket_id }
    end

    assert_redirected_to survey_question_path(assigns(:survey_question))
  end

  test "should show survey_question" do
    get :show, id: @survey_question
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @survey_question
    assert_response :success
  end

  test "should update survey_question" do
    patch :update, id: @survey_question, survey_question: { answer_text: @survey_question.answer_text, description: @survey_question.description, event_id: @survey_question.event_id, field_type: @survey_question.field_type, free_text: @survey_question.free_text, free_text_active: @survey_question.free_text_active, is_active: @survey_question.is_active, question_text: @survey_question.question_text, response_required: @survey_question.response_required, ticket_id: @survey_question.ticket_id }
    assert_redirected_to survey_question_path(assigns(:survey_question))
  end

  test "should destroy survey_question" do
    assert_difference('SurveyQuestion.count', -1) do
      delete :destroy, id: @survey_question
    end

    assert_redirected_to survey_questions_path
  end
end
