module Bunyan
	class EventAdminController < ApplicationAdminController 

		def index
			@events = Event.order( created_at: :desc ).page( params[:page] )
		end

		def edit
			@event = Event.find( params[:id] )	
		end
	end
end