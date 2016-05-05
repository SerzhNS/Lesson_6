# encoding: UTF-8

# ===================== Vagon ====================
class Vagon
	@@total_num = 0
	attr_accessor :num, :type


	def initialize(type)
		@@total_num += 1
		@type = type
		@num = @@total_num
	end
end

class PassangerVagon < Vagon
	def initialize(type = :pass)
		super
	end	
end

class CargoVagon < Vagon
	def initialize(type = :carg)
		super
	end
end	