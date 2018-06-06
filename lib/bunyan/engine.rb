

##### require gems here?
# require 'browser'
# require 'user_agent_parser'

module Bunyan

	class << self
		##### config vars
		mattr_accessor 	:bot_blacklist
		mattr_accessor 	:event_categories
		mattr_accessor 	:event_service_class_name
		mattr_accessor 	:log_bots
		mattr_accessor 	:default_ttl


		self.bot_blacklist = /google|yahoo|bing|yandex/i

		self.event_categories = {
			'pageview'			=> 'browse',
			'click' 			=> 'browse',

			'optin'				=> 'account',
			'login'				=> 'account',
			'logout'			=> 'account',
			'register' 			=> 'account',
			'forgot_pw'			=> 'account',
			'reset_pw' 			=> 'account',
			'update_profile'	=> 'account',

			'add_cart' 			=> 'ecom',
			'remove_cart' 		=> 'ecom',
			'update_cart' 		=> 'ecom', # quantity
			'apply_discount' 	=> 'ecom',
			'init_checkout' 	=> 'ecom',
			'purchase'			=> 'ecom',
			'renewal'			=> 'ecom',
			'parcel_shipped' 	=> 'ecom',
			'parcel_recieved' 	=> 'ecom',
			'parcel_failed' 	=> 'ecom',
			'refund' 			=> 'ecom',

			'transaction_sxs'		=> 'ecom',
			'transaction_failed'	=> 'ecom',

			'update_bill_addr' 	=> 'ecom',
			'update_ship_addr' 	=> 'ecom',
			'update_payment' 	=> 'ecom',

			'cancel_sub' 			=> 'ecom',
			'reactivate_sub' 		=> 'ecom',
			'update_sub' 			=> 'ecom', # interval, quantity, next_date


			'comment' 			=> 'social',
			'review' 			=> 'social',
			'add_topic' 		=> 'social',
			'add_post' 			=> 'social',
			'vote' 				=> 'social',
			'follow' 			=> 'social',
		}

		self.event_service_class_name = "Bunyan::EventService"

		self.log_bots = false
		self.default_ttl = 10.seconds


	end

	# this function maps the vars from your app into your engine
	def self.configure( &block )
		yield self
	end



	class Engine < ::Rails::Engine
		isolate_namespace Bunyan

		##### send application controller stuff? copied from swell_media
		# initializer "bunyan.load_helpers" do |app|
		# 	ActionController::Base.send :include, Bunyan::ApplicationControllerExtensions
		# end


		##### setup rspec testing??? copied from swell_analytics
		config.generators do |g|
			g.test_framework :rspec, :fixture => false
			g.fixture_replacement :factory_girl, :dir => 'spec/factories'
			g.assets false
			g.helper false
		end

	end
end
