module ApplicationHelper


	#set site title
	def title(title = nil)
		if title.present?
			content_for :title, title
		else
			content_for?(:title) ? content_for(:title)  + ' | ' + APP_CONFIG['default_title'] : APP_CONFIG['default_title']
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
			subdir = 'themes/'
		end

		if(!event.external_image.nil? && !event.external_image.blank? ) 
			@style_bg = event.external_image
		elsif(!event.background_img.nil? && !event.background_img.blank? )
			# if dir == true
			# 	@style_bg = event.background_img.url(:thumb)
			# else
				@style_bg = event.background_img
			# end
		elsif (event.layout_style? && !event.show_custom) 
			@style_bg = subdir + event.layout_style.to_s + '_bg.jpg'
		else	
			@style_bg = subdir+ 'cityscape_thumb.jpg'
		end

		#logger.debug "GIVE ME CITYSCAPE: #{event.layout_style}"
	end


	def show_proper_date(event = nil, layout = true)

		#if date null
		if(event.date_start.nil? || event.date_start == '' )
			firstLineDate = 'TBD'
			secondLineDate = ''
			
		else
			firstLineDate = event.date_start.to_date.strftime("%B ") + event.date_start.to_date.strftime("%e, ") + event.date_start.to_date.strftime("%Y")
			secondLineDate = ''
			if(event.time_start != '' && !event.time_start.nil?) #if event time start is not blank
				if(!event.date_end.nil? && event.date_end != '') 	#if date end is not blank
					firstLineDate += event.time_start.to_time.strftime(", %l:%M %p") #append time after first date
				else
					if layout
						secondLineDate = event.time_start.to_time.strftime("%l:%M %p") # append time like normal
					else
						secondLineDate = event.time_start.to_time.strftime(", %l:%M %p")
					end
				
				end
			else
				secondLineDate = ''
			end
		
			if(!event.date_end.nil? && event.date_end != '') #if date end is not blank
				secondLineDate += event.date_end.to_date.strftime(" - %B ") + event.date_end.to_date.strftime("%e, ") + event.date_end.to_date.strftime("%Y")

			end

			if(event.time_end != '' && !event.time_end.nil?)

				if (!event.date_start.nil? && event.date_start != '')

					if layout
						if (event.time_start != '' && event.time_start.nil?)
							secondLineDate += event.time_end.to_time.strftime("%l:%M %p")
						else
							secondLineDate += event.time_end.to_time.strftime(", %l:%M %p")
						end
					 else

					 	secondLineDate += event.time_end.to_time.strftime(" - %l:%M %p")
					 end 
				else 
					secondLineDate += (!event.date_end.nil? && event.date_end != '')? ', ': ' - '
					secondLineDate += event.time_end.to_time.strftime("%l:%M %p")
				end
			end

	


		end


		if layout

			content_tag(:div, firstLineDate)  + content_tag(:div, secondLineDate)
		else
			content_tag(:div, firstLineDate + secondLineDate)
		end 


	end

	def show_attendance(attendee)

		@reply = !attendee.attending.blank? ? (attendee.attending ? 'yes': 'no') : 'not yet replied'

	end

	def check_registration_status
		#if number of attendees for event > event registration limit for user
			# don't allow users to register/close registration
		# else
			#if past registration date and time
				# close registration
			# else
				# open registration
			# end
		# end
	end

	def flash_class(level)
	   case level.to_sym
	   when :event_success then "ec-success"
	   when :notice then "alert alert-info"
	   when :success then "alert alert-success"
	   when :error then "alert alert-error"
	   when :alert then "alert alert-error"
	   end
	end

 
end
