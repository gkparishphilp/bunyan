module Bunyan
	module ApplicationHelper

		def bunyan_system_log( opts={} )
			@event_service ||= Bunyan::EventService.new

			opts[:name] ||= opts[:event] || opts[:event_name]
			opts[:target_obj] ||= opts[:on] || opts[:target]

			@event_service.log_event( opts )
		end

		def bunyan_log( opts={} )
			@event_service ||= Bunyan::EventService.new

			client_uuid ||= cookies[:clientuuid] || SecureRandom.uuid

			opts[:name] ||= opts[:event] || opts[:event_name] || 'pageview' # default to pageview if no other event name specified
			opts[:target_obj] ||= opts[:on] || opts[:target]

			if opts[:name] == 'pageview'
				if opts[:target_obj].present?
					opts[:content] ||= "viewed #{request.method} #{request.path} for #{opts[:target_obj].to_s}"
				else
					opts[:content] ||= "viewed #{request.method} #{request.path}."
				end
			end

			opts[:user] ||= current_user


			opts.merge!( {
				client_uuid: 				client_uuid,
				user: 						opts[:user],
				user_agent: 				request.user_agent,
				page_name: 					@page_meta[:title],
				country: 					request.headers['CF-IPCountry'],
				ip: 						request.headers['CF-Connecting-IP'] || request.remote_ip,
				campaign_source: 			params[:utm_source],
				campaign_medium: 			params[:utm_medium],
				campaign_term: 				params[:utm_term],
				campaign_content: 			params[:utm_content],
				campaign_name: 				params[:utm_campaign],
				referrer_url: 				request.referrer,
				page_url: 					request.original_url,
			} )

			@event_service.log_event( opts )

			cookies[:clientuuid] = {
				:value => client_uuid,
				:expires => 1.year.from_now
			}

		end



	end
end
