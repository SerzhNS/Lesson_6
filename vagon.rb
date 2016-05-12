# encoding: UTF-8

# ===================== Vagon ====================
class Vagon

	include Manufacturer
	include InstanceCounter

	attr_reader :num, :type

	def initialize
		@@num = register_instance(self)
		@type = self.class		# Тип вагона будем определять по значению класса его объекта
	end
end
