module Validation

	STATION_TEMPLATE = /\w+/
	TRAIN_TEMPLATE = /\w{3}-?\w{2}/
	ROUTE_TEMPLATE = /\w{3}/
	TRAIN_TYPE_TEMPLATE = /pass|cargo/

	module ClassMethods 
		attr_accessor :list

		def exist?(name)						# Объект - класс
			self.list.include?(name)
		end
	end
	
	module InstanceMethods

		attr_accessor :name
		
	end
	
	def self.included(receiver)
		receiver.extend         ClassMethods
		receiver.send :include, InstanceMethods
	end
end