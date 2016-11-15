class SurveyQuestionsController < ApplicationController
  before_action :set_survey_question, only: [:show, :edit, :update, :destroy, :remove_question]

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
    @event = Event.find_by_slug(params[:slug])
    survey_question_params["event_id"] = params["survey_question"]["event_id"].to_s 


    @survey_question = SurveyQuestion.new(survey_question_params)
    @survey_question.save
    redirect_to slugger_path(@event) + '?editing=true'
  end

  def update
    @event = Event.find(@survey_question.event_id)


    @survey_question.update(survey_question_params)
    respond_to do |format|
      format.html { redirect_to slugger_path(@event) + '?editing=true', notice: 'Survey Question was successfully created.' }
      format.js   { render action: 'confirmation', status: :created, location: slugger_path(@event) + '?editing=true' }
      format.json { render :show, status: :created }
    end

    #respond_with(@survey_question)
  end

  def remove_question
    @event = Event.find(@survey_question.event_id)
    @answer_count = SurveyAnswer.where(:survey_question_id => @survey_question.id).count
    
    if @answer_count > 0
    
    else
       @survey_question.destroy
    end
    # @ticket.destroy
    respond_to do |format|
      format.html { redirect_to slugger_path(@event) + '?editing=true', notice: 'Ticket was successfully destroyed.' }
      format.js   { render action: 'confirmation', status: :created, location: slugger_path(@event) + '?editing=true' }
      format.json { render :show, status: :created }
    end

    #redirect_to slugger_path(@event) + '?editing=true'

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
      params.require(:survey_question).permit(:question_text, :response_required, :description, :answer_text, :field_type, :ticket_id, :event_id, :is_active, :free_text_active, :free_text, :apply_to_buyer)
    end
end
