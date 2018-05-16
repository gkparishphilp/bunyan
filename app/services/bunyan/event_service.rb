
module Bunyan

	class EventService

		def log_event( opts={} )
			if false   #   Bunyan.async_event_logging?
				Bunyan.event_worker_class_name.constantize.prepare_and_perform_async( opts )
			else
				self.log!( opts )
			end
		end


		protected

			def log!( opts )
				client_uuid = opts.delete( :client_uuid )

				if client_uuid.present?

					client = Client.find_by( uuid: client_uuid )
					client ||= Client.create_from_options( opts.merge!( uuid: client_uuid ) )

					client.update( user: opts[:user] ) if opts[:user].present? && client.user != opts[:user]

					opts[:client] = client
					
				end


				event = Event.create_from_options( opts )

			end


	end

end
