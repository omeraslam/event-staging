class PagesController < ApplicationController
  def info

  end
  
  def home      
  end

  def terms
  end

  def privacy
  end
  
  def about
  end

	
	def pricing
	end


  def error404
  end

  def features
  end

  def explore

       @themes = Theme.all
       
  end


end
