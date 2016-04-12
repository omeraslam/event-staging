class PagesController < ApplicationController

  
  def home      
  end

  def terms
  end

  def privacy
  end
  
  def about
    #no design 
  end

	
	def pricing
	end


  def error404
    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def features
    #no design 
  end


  def contact
  end

  def facebook
  end

  def press
  end


  def explore
    #no design 
    @themes = Theme.all
  end


end
