class PagesController < ApplicationController

  
  if !Rails.env.development?
    force_ssl
  end
  before_filter :ensure_proper_root_domain


  def home      
  end

  def terms
  end

  def privacy
  end
  
  def about
    #no design 
  end

  def robots
    respond_to :text
    expires_in 6.hours, public: true
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

  def customization
  end

  def ensure_proper_root_domain

    if ((request.subdomain.present? && request.subdomain != 'www'))
      redirect_to params.merge({subdomain: 'www'})
    end
  end


  def explore
    #no design 
    @themes = Theme.all
  end


end
