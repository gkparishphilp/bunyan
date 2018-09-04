module Bunyan
	module Concerns

		module ApplicationServiceConcern
			extend ActiveSupport::Concern

			####################################################
			# Class Methods

			module ClassMethods

			end


			####################################################
			# Instance Methods


			protected


				def log_event( options={} )
					begin
						@event_service ||= Bunyan.event_service_class_name.constantize.new
						@event_service.log_event( options )
					rescue Exception => e
						raise e unless Rails.env.production?
						NewRelic::Agent.notice_error(e) if defined?( NewRelic )
					end
				end

		end

	end
end
