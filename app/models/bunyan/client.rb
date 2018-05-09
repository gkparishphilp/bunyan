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

			client.user = options[:user]

			client.landing_page_referrer_url	= options[:referrer_url]
			client.landing_page_url 			= options[:page_url]

			client.properties 	= options[:properties]

			client.campaign_source = options[:campaign_source]
			client.campaign_medium = options[:campaign_medium]
			client.campaign_name = options[:campaign_name]
			client.campaign_term = options[:campaign_term]
			client.campaign_content = options[:campaign_content]
			client.campaign_cost = options[:campaign_cost]

			client.landing_page_referrer_url = options[:referrer_url]
			client.landing_page_referrer_host = options[:referrer_host]
			client.landing_page_referrer_path = options[:referrer_path]

			client.landing_page_url = options[:page_url]
			client.landing_page_host = options[:page_host]
			client.landing_page_path = options[:page_path]

			if options[:user_agent].present?
				user_agent = UserAgentParser.parse options[:user_agent]
				browser = Browser.new options[:user_agent]

				# # don't record anything for bots
				# raise "Got a Bot: #{browser.bot.name}" unless browser.bot.name.blank?
				return false unless browser.bot.name.blank?

				client.browser_family					= user_agent.family
				client.browser_version					= user_agent.version.to_s
				client.browser_major_version			= user_agent.version.try(:major)
				client.browser_minor_version			= user_agent.version.try(:minor)
				client.operating_system_name			= user_agent.os.try(:name)
				client.operating_system_version			= user_agent.os.version
				client.operating_system_major_version 	= user_agent.os.version.try(:major)
				client.operating_system_minor_version 	= user_agent.os.version.try(:minor)
				client.device_type						= 'tablet' if browser.device.try(:tablet?)
				client.device_type						= 'mobile' if browser.device.try(:mobile?)
				client.device_type						= 'tv' if browser.device.try(:tv?)
				client.device_type						= 'console' if browser.device.console?
				client.device_family					= user_agent.device.try(:family)
				client.device_brand						= user_agent.device.try(:brand)
				client.device_model						= user_agent.device.try(:model)
			end

			if options[:landing_page_referrer_url].present?
				begin
					uri = URI( options[:landing_page_referrer_url] )
					client.landing_page_referrer_host ||= uri.host
					client.landing_page_referrer_path ||= ( uri.query.present? ? "#{uri.path}?#{uri.query}" : uri.path )
				rescue URI::InvalidURIError => e
				end
			end

			if options[:landing_page_url].present?
				begin
					uri = URI( options[:landing_page_url] )
					client.landing_page_host ||= uri.host
					client.landing_page_path ||= ( uri.query.present? ? "#{uri.path}?#{uri.query}" : uri.path )
				rescue URI::InvalidURIError => e
				end
			end

			client.save 

			return client

		end


		def to_s
			user = self.user || 'Anonymous'
			"#{self.id} #{user}'s #{self.device_type} #{self.device_family} #{device_brand} #{device_model}"
		end
	end
end