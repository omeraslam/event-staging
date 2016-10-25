class SurveyQuestionsController < ApplicationController
  before_action :set_survey_question, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @survey_questions = SurveyQuestion.all
    respond_with(@survey_questions)
  end

  def show
    respond_with(@survey_question)
  end

  def new
    @survey_question = SurveyQuestion.new
    respond_with(@survey_question)
  end

  def edit
  end

  def create

    survey_question_params["event_id"] = params["survey_question"]["event_id"].to_s 

    @event = Event.find((params["survey_question"]["event_id"]).to_i)

    @survey_question = SurveyQuestion.new(survey_question_params)
    @survey_question.save
    #respond_to slugger_path( @event) + "?editing=true"
    respond_with(@survey_question)
  end

  def update
    @survey_question.update(survey_question_params)
    respond_with(@survey_question)
  end

  def destroy
    @survey_question.destroy
    respond_with(@survey_question)
  end

  private
    def set_survey_question
      @survey_question = SurveyQuestion.find(params[:id])
    end

    def survey_question_params
      params.require(:survey_question).permit(:question_text, :response_required, :description, :field_type, :ticket_id, :event_id, :is_active, :free_text_active, :free_text)
    end
end
