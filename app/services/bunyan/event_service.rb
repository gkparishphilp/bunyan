
module Bunyan

	class EventService

		def log_event( name, options = {} )
			if false   #   Bunyan.async_event_logging?
				Bunyan.event_worker_class_name.constantize.prepare_and_perform_async( name, options )
			else
				self.log!( name, options )
			end
		end

		protected

			def log!( name, options={} )
				client_uuid = options.delete( :client_uuid )

				client = Client.find_by( uuid: client_uuid )
				client ||= Client.create_from_options( options.merge( uuid: client_uuid ) )

				# can't log without a valid cookied device
				raise "Got No Device!!!" unless client.present?
				return false unless client.present?

				options.merge!( client: client )
				options.merge!( name: name )

				event = Event.create_from_options( options )

			end


	end

end