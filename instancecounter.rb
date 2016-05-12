module InstanceCounter
	def self.inclueded(base)
		base.extend ClassMethods
		base.send :include, InstanceMethods
	end	

	module ClassMethods
		def instances(class_name)
			qnty = 0
			list_instances.each { |e| qnty += 1 if e.class == class_name  }
			qnty
		end
	end

	module InstanceMethods
		@@list_instances = nil
		def list_instances
			@@list_instances
		end
		private
		def register_instance(obj)
			@@list_instances ||= [] 
			@@list_instances << obj
		end

	end

end

=begin
class A
	include InstanceCounter
	def initialize
		register_instance(self)
		
	end
	
end

class B < A
	
end
=end