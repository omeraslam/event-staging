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


	def show_proper_date(event = nil, layout = true)
		logger.debug "#{event.date_start}"

		#if date null
		if(event.date_start.nil? || event.date_start == '' )
			str = 'TBD'
			
		else
			str = event.date_start.to_date.strftime("%B ") + event.date_start.to_date.strftime("%e, ") + event.date_start.to_date.strftime("%Y")
			if(event.time_start != '' && !event.time_start.nil?)
				if(!event.date_end.nil? && event.date_end != '')
					str += event.time_start.to_time.strftime(", %l:%M %p")
				else
					str2 = event.time_start.to_time.strftime("%l:%M %p")
				end
			end
		
			if(!event.date_end.nil? && event.date_end != '')
				str2 = event.date_end.to_date.strftime(" - %B ") + event.date_end.to_date.strftime("%e, ") + event.date_end.to_date.strftime("%Y")
			end

			if(event.time_end != '' && !event.time_end.nil?)
				str2 += (!event.date_end.nil? && event.date_end != '')? ', ': ' - '
				str2 += event.time_end.to_time.strftime("%l:%M %p")
			end

			if layout
				content_tag(:div, str)  + content_tag(:div, str2)
			else
				content_tag(:div, str+ str2)
			end 


		end



	end

	def show_attendance(attendee)

		@reply = !attendee.attending.blank? ? (attendee.attending ? 'yes': 'no') : 'not yet replied'

	end

 
end
