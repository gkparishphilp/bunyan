module Bunyan
	class Event < ApplicationRecord

		belongs_to 		:client # client is not optional, optional: true
		belongs_to 		:target_obj, polymorphic: true, optional: true
		belongs_to 		:user, optional: true


		def self.create_from_options( options )
			
			# TODO check for and reject duplicate events
			if dup_event = Event.where( client: options[:client], name: options[:name], page_url: options[:page_url] ).where( 'updated_at > :t', t: 10.seconds.ago ).first
				#dup_event.touch( :updated_at )
				return false 
			end

			event = self.new( name: options[:name], client: options[:client], user: options[:user], target_obj: options[:target_obj], category: options[:category], content: options[:content], value: options[:value] )

			event.campaign_source = options[:campaign_source] || options[:client].campaign_source
			event.campaign_medium = options[:campaign_medium] || options[:client].campaign_medium
			event.campaign_name = options[:campaign_name] || options[:client].campaign_name
			event.campaign_term = options[:campaign_term] || options[:client].campaign_term
			event.campaign_content = options[:campaign_content] || options[:client].campaign_content
			event.campaign_cost = options[:campaign_cost] || options[:client].campaign_cost

			event.referrer_url = options[:referrer_url]
			event.referrer_host = options[:referrer_host]
			event.referrer_path = options[:referrer_path]

			event.page_url = options[:page_url]
			event.page_host = options[:page_host]
			event.page_path = options[:page_path]
			event.page_name = options[:page_name]


			event.save

			return event

		end




		def to_s
			user = self.user || 'Anonymous'

			"#{user} #{content}"
		end

	end
end