module ApplicationHelper
	#set site title
	def title(title = nil)
		if title.present?
			content_for :title, title
		else
			content_for?(:title) ? APP_CONFIG['default_title'] + ' | ' + content_for(:title) : APP_CONFIG['default_title']
		end
	end

	#set meta keywords
	def meta_keywords(tags = nil)
	    if tags.present?
	      content_for :meta_keywords, tags
	    else
	      content_for?(:meta_keywords) ? [content_for(:meta_keywords), APP_CONFIG['meta_keywords']].join(', ') : APP_CONFIG['meta_keywords']
	    end
	end

	#set meta description
	def meta_description(desc = nil)
	    if desc.present?
	      content_for :meta_description, desc
	    else
	      content_for?(:meta_description) ? content_for(:meta_description) : APP_CONFIG['meta_description']
	    end
	end

	def background_checker(event = nil, dir = true)
		if dir == true
			subdir = '/assets/themes/'
		else 
			subdir = '/themes/'
		end

		if(event.layout_style? && !event.show_custom) 
			@style_bg = subdir + event.layout_style.to_s + '_thumb.jpg'
		elsif(!event.background_img.nil?)
			@style_bg = event.background_img 
		else
			@style_bg = subdir+ 'cityscape_thumb.jpg'
		end
	end
 
end
