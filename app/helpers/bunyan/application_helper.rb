module Bunyan
	module ApplicationHelper

		def bunyan_system_log( opts={} )
			@event_service ||= Bunyan.event_service_class_name.constantize.new

			# Merge options aliases
			opts[:name] ||= opts[:event] || opts[:event_name]
			opts[:target_obj] ||= opts[:on] || opts[:target]

			@event_service.log_event( opts )
		end

		def bunyan_merge_request_options!( opts = {} )
			# Set all the contextual values contained as
			# part of the request. params, headers, users, etc

			opts[:client_uuid] =				opts[:client_uuid].presence || cookies[:clientuuid].presence
			opts[:user] ||= 					current_user
			opts[:user_agent] ||=				request.user_agent
			opts[:page_name] ||=				@page_meta[:title]
			opts[:country] ||=					request.headers['CF-IPCountry']
			opts[:ip] ||=						request.headers['CF-Connecting-IP'] || request.remote_ip
			opts[:campaign_source] ||=			params[:utm_source]
			opts[:campaign_medium] ||=			params[:utm_medium]
			opts[:campaign_term] ||=			params[:utm_term]
			opts[:campaign_content] ||=			params[:utm_content]
			opts[:campaign_name] ||=			params[:utm_campaign]
			opts[:referrer_url] ||=				request.referrer
			opts[:page_url] ||=					request.original_url

			opts
		end

		def bunyan_clientize( opts={} )
			@event_service ||= Bunyan.event_service_class_name.constantize.new


			bunyan_merge_request_options!(opts)

			# Fetch or Create a universally unique random client id (uuid)
			client_uuid = opts[:client_uuid] = opts[:client_uuid].presence || SecureRandom.uuid

			@event_service.clientize( opts )

			cookies[:clientuuid] = {
				:value => client_uuid,
				:expires => 1.year.from_now
			}

			client_uuid
		end

		def bunyan_log( opts={} )
			@event_service ||= Bunyan.event_service_class_name.constantize.new

			# Merge options aliases and set event defaults
			opts[:name] ||= opts[:event] || opts[:event_name] || 'pageview' # default to pageview if no other event name specified
			opts[:target_obj] ||= opts[:on] || opts[:target]

			if opts[:name] == 'pageview'
				if opts[:target_obj].present?
					opts[:content] ||= "viewed #{request.method} #{request.path} for #{opts[:target_obj].to_s}"
				else
					opts[:content] ||= "viewed #{request.method} #{request.path}."
				end
			end

			bunyan_merge_request_options!(opts)

			@event_service.log_event( opts )

		end



	end
end
