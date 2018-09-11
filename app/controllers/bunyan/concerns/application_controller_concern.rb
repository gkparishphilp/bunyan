module Bunyan
	module Concerns

		module ApplicationControllerConcern
			extend ActiveSupport::Concern

			included do
				include Bunyan::ApplicationHelper
			end


			####################################################
			# Class Methods

			module ClassMethods

			end


			####################################################
			# Instance Methods


			protected

		end

	end
end
