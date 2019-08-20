require 'user_agent_parser'
require 'browser'

module Bunyan
	class Client < ApplicationRecord

		belongs_to 	:user, optional: true

		has_many 	:events


		def self.create_from_options( options )
			# don't create client if device not cookied
			raise "No uuid!!!" unless options[:uuid].present?
			return false unless options[:uuid].present?

			client = self.new( uuid: options[:uuid] )
			client.ip = options[:ip]
			client.user_agent = options[:user_agent]
			client.country = options[:country]
			client.state = options[:state]
			client.city = options[:city]

			client.user = options[:user]

			client.properties 	= options[:properties]

			client.campaign_source = options[:campaign_source]
			client.campaign_medium = options[:campaign_medium]
			client.campaign_name = options[:campaign_name]
			client.campaign_term = options[:campaign_term]
			client.campaign_content = options[:campaign_content]
			client.campaign_cost = options[:campaign_cost]

			client.partner_source = options[:partner_source]
			client.partner_id = options[:partner_id]

			client.referrer_url = options[:referrer_url]
			client.referrer_host = options[:referrer_host]
			client.referrer_path = options[:referrer_path]
			client.referrer_params = options[:referrer_params]
			if options[:referrer_url].present?
				begin
					uri = URI( options[:referrer_url] )
					client.referrer_host ||= uri.host
					client.referrer_path ||= uri.path
					client.referrer_params ||= uri.query
				rescue URI::InvalidURIError => e
				end
			end

			client.lander_url = options[:page_url]
			client.lander_host = options[:page_host]
			client.lander_path = options[:page_path]
			client.lander_params = options[:page_params]
			if options[:page_url].present?
				begin
					uri = URI( options[:page_url] )
					client.lander_host ||= uri.host
					client.lander_path ||= uri.path
					client.lander_params ||= uri.query
				rescue URI::InvalidURIError => e
				end
			end

			if options[:user_agent].present?
				user_agent = UserAgentParser.parse options[:user_agent]
				browser = Browser.new options[:user_agent]

				# # don't record anything for bots
				# raise "Got a Bot: #{browser.bot.name}" unless browser.bot.name.blank?

				# TODO - change to whitelist of NON-loggable bots
				# e.g.:
				if Bunyan.log_bots
					return false if browser.bot.name =~ Bunyan.bot_blacklist
				end

				client.is_bot = browser.bot.name.present?

				client.browser_family					= user_agent.family
				client.browser_version					= user_agent.version.to_s
				client.os_name							= user_agent.os.try(:name)
				client.os_version						= user_agent.os.version
				client.device_type						= 'tablet' if browser.device.try(:tablet?)
				client.device_type						= 'mobile' if browser.device.try(:mobile?)
				client.device_type						= 'tv' if browser.device.try(:tv?)
				client.device_type						= 'console' if browser.device.console?
				client.device_family					= user_agent.device.try(:family)
				client.device_brand						= user_agent.device.try(:brand)
				client.device_model						= user_agent.device.try(:model)
			end


			client.save

			return client

		end


		def to_s
			user = self.user || 'Anonymous'
			"#{self.id} #{user}'s #{self.device_type} #{self.device_type} #{os_name} #{os_version} #{browser_family} #{browser_version}"
		end
	end
end
