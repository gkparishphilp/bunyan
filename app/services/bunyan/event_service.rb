
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

				client = Client.find_by( uuid: client_uuid )
				client ||= Client.create_from_options( opts.merge!( uuid: client_uuid ) )

				client.update( user: opts[:user] ) if client.user != opts[:user]

				# can't log without a valid cookied device
				# raise "Got No Device!!!" unless client.present?
				return false unless client.present?

				opts[:client] = client

				event = Event.create_from_options( opts )

			end


	end

end