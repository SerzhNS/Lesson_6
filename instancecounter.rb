module InstanceCounter
	@@list_of_instances = 0

	def self.instances
		@@list_of_instances		
	end

	private

	def register_instance
		@@list_of_instances += 1	
	end

end