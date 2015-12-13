class UrlsController < ApplicationController
  def new
  end


  def create
    if !params[:url].blank?
      client = Bitly.client
      @url = client.shorten(params[:url])
    end
  end

end
