
module Bunyan

	class EventService


		def clientize( opts={} )
			if false   #   Bunyan.async_client_logging?
				Bunyan.client_worker_class_name.constantize.prepare_and_perform_async( opts )
			else
				self.clientize!( opts )
			end
		end

		def log_event( opts={} )
			if false   #   Bunyan.async_event_logging?
				Bunyan.event_worker_class_name.constantize.prepare_and_perform_async( opts )
			else
				self.log!( opts )
			end
		end


		protected


			def clientize!( opts={} )


				client_uuid = opts.delete( :client_uuid )

				if client_uuid.present?

					# lock it up!
					client = Client.find_by( uuid: client_uuid )
					client ||= Client.create_from_options( opts.merge!( uuid: client_uuid ) )
					client.update_from_options( opts )
					# unlock

				end


				client

			end

			def log!( opts )

				# Aliases
				opts[:name] ||= opts[:event] || opts[:event_name]
				opts[:target_obj] ||= opts[:on] || opts[:target]

				client_uuid = opts.delete( :client_uuid )
				opts[:client] = Client.find_by( uuid: client_uuid ) if client_uuid.present?

				event = Event.create_from_options( opts )

			end


	end

end
