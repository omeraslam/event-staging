class ThemesController < ApplicationController
  before_action :set_theme, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @themes = Theme.all
    respond_with(@themes)
  end

  def show
    respond_with(@theme)
  end

  def new
    @theme = Theme.new
    respond_with(@theme)
  end

  def edit
  end

  def create
    @theme = Theme.new(theme_params)
    @theme.save
    respond_with(@theme)
  end

  def update
    @theme.update(theme_params)
    respond_with(@theme)
  end

  def destroy
    @theme.destroy
    respond_with(@theme)
  end

  private
    def set_theme
      @theme = Theme.find(params[:id])
    end

    def theme_params
      params.require(:theme).permit(:name, :slug, :active, :font_type, :bg_color, :bg_opacity, :layout_type, :icon)
    end
end
