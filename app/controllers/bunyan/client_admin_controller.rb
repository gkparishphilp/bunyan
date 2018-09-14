module Bunyan
	class ClientAdminController < ApplicationAdminController


		def edit
			@client = Client.find( params[:id] )
		end

		def index
			@clients = Client.order( created_at: :desc ).page( params[:page] )
		end

	end
end
