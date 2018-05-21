class BunyanMigration < ActiveRecord::Migration[5.1]
	def change

		create_table :bunyan_clients, force: true do |t| # cache this model's attributes, and have it expire after session is dead for X minutes (TTL)
			t.references	:user
			t.string		:uuid

			t.string		:ip
			t.string		:user_agent

			t.string		:country
			t.string		:state
			t.string		:city

			t.string		:referrer_url
			t.string		:referrer_host
			t.string		:referrer_path
			t.string		:referrer_params

			t.string		:lander_url
			t.string		:lander_host
			t.string		:lander_path
			t.string		:lander_params

			t.string		:campaign_source
			t.string		:campaign_medium
			t.string		:campaign_term
			t.string		:campaign_content
			t.string		:campaign_name
			t.integer		:campaign_cost

			t.string		:partner_source
			t.string		:partner_id

			t.boolean 		:is_bot

			t.string		:device_type
			t.string		:device_family
			t.string		:device_brand
			t.string		:device_model

			t.string		:os_name
			t.string		:os_version

			t.string		:browser_family
			t.string		:browser_version

			t.hstore 		:properties

			t.timestamps
		end
		add_index :bunyan_clients, :uuid, unique: true

		
		create_table :bunyan_events, force: true do |t|
			t.references	:user
			t.references 	:client
			t.references 	:target_obj, polymorphic: true

			# EVENT SCOPE
			t.string		:name
			t.string		:category # browse, signup, social, commerce
			t.text 			:content
			t.integer		:value, default: 0

			# CLIENT SCOPE
			t.string		:ip
			t.string		:user_agent

			t.string		:campaign_source
			t.string		:campaign_medium
			t.string		:campaign_name
			t.string		:campaign_term
			t.string		:campaign_content
			t.integer		:campaign_cost

			t.string		:partner_source
			t.string		:partner_id

			t.string		:referrer_url
			t.string		:referrer_host
			t.string		:referrer_path
			t.string		:referrer_params

			t.string		:page_url
			t.string		:page_host
			t.string		:page_path
			t.string 		:page_params
			t.string		:page_name

			t.hstore		:properties

			t.timestamps
		end
		add_index :bunyan_events, [:name, :created_at, :page_url]

	end
end
