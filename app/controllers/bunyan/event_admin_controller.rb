module Bunyan
	class EventAdminController < SwellMedia::AdminController 

		def index
			@events = Event.order( created_at: :desc ).page( params[:page] )
		end

	end
end