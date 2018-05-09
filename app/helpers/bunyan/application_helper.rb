module Bunyan
	module ApplicationHelper

		def bunyan_log( opts={} )
			@event_service ||= Bunyan::EventService.new

			client_uuid = cookies[:clientuuid] || SecureRandom.uuid

			opts[:name] ||= opts[:event] || opts[:event_name]
			opts[:target_obj] ||= opts[:on] 

			raise "trying to log event without name" if opts[:name].blank?

			opts.merge!( {
				client_uuid: 				client_uuid,
				user: 						current_user,
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
