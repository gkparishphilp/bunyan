module Bunyan
	class Event < ApplicationRecord

		belongs_to 		:client, optional: true
		belongs_to 		:target_obj, polymorphic: true, optional: true
		belongs_to 		:user, optional: true


		def self.create_from_options( options )

			# TODO check for and reject duplicate events
			ttl = options[:ttl] || Bunyan.default_ttl
			if options[:client] && Event.where( client: options[:client], name: options[:name], page_url: options[:page_url] ).where( 'updated_at > :t', t: ttl.ago ).present?
				#dup_event.touch( :updated_at )
				return false
			end

			event = self.new(
				name: options[:name],
				client: options[:client],
				user: options[:user],
				target_obj_type: options[:target_obj].try( :class ).try( :base_class ).try( :name ),
				target_obj_id: options[:target_obj].try( :id ),
				category: options[:category],
				content: options[:content],
				value: options[:value]
			)

			event.created_at = options[:created_at] if options[:created_at].present?

			event.campaign_source = options[:campaign_source]
			event.campaign_medium = options[:campaign_medium]
			event.campaign_name = options[:campaign_name]
			event.campaign_term = options[:campaign_term]
			event.campaign_content = options[:campaign_content]
			event.campaign_cost = options[:campaign_cost]

			event.partner_source = options[:partner_source]
			event.partner_id = options[:partner_id]

			event.referrer_url = options[:referrer_url]
			event.referrer_host = options[:referrer_host]
			event.referrer_path = options[:referrer_path]

			event.page_url = options[:page_url]
			event.page_host = options[:page_host]
			event.page_path = options[:page_path]
			event.page_name = options[:page_name]

			event.category = options[:category] || Bunyan.event_categories[options[:name] ]


			event.save

			return event

		end




		def to_s
			user = self.user || 'Anonymous'

			"#{user} #{content}"
		end

	end
end
