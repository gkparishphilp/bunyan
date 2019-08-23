
module Bunyan

	class EventService

		def log_event( opts={} )
			if false   #   Bunyan.async_event_logging?
				Bunyan.event_worker_class_name.constantize.prepare_and_perform_async( opts )
			else
				self.log!( opts )
			end
		end

		def is_visit?( event )
			event && event.name == 'visit' && event.category == 'browse'
		end

		protected

			def log!( opts )

				# Aliases
				opts[:name] ||= opts[:event] || opts[:event_name]
				opts[:parent_obj] ||= opts[:on] || opts[:parent] || opts[:target]
				opts[:result_obj] ||= opts[:result]


				client_uuid = opts.delete( :client_uuid )

				if client_uuid.present?

					client = Client.find_by( uuid: client_uuid )
					client ||= Client.create_from_options( opts.merge!( uuid: client_uuid ) )

					client.update( user: opts[:user] ) if opts[:user].present? && client.user != opts[:user]

					opts[:client] = client

				end


				event = Event.create_from_options( opts )

				if is_visit?( event )
					client.last_campaign_source = event.campaign_source
					client.last_campaign_medium = event.campaign_medium
					client.last_campaign_name = event.campaign_name
					client.last_campaign_term = event.campaign_term
					client.last_campaign_content = event.campaign_content
					client.last_campaign_cost = event.campaign_cost
					client.last_partner_source = event.partner_source
					client.last_partner_id = event.partner_id
					client.last_referrer_url = event.referrer_url
					client.last_referrer_host = event.referrer_host
					client.last_referrer_path = event.referrer_path
					client.last_referrer_params = event.referrer_params
					client.last_lander_url = event.page_url
					client.last_lander_host = event.page_host
					client.last_lander_path = event.page_path
					client.last_lander_params = event.page_params
					client.save
				end

				event

			end


	end

end
