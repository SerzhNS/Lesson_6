# encoding: UTF-8

# ===================== Vagon ====================
class Vagon

	include Manufacturer
	include InstanceCounter

	attr_reader :type

	def initialize(manufacturer = "TVZ")
		register_instance										# Зарегистрировать экземпляр
		@type = self.class							# Задать тип вагона по типу подкласса
		self.man_name = manufacturer  			# Передать имя производителя
	end
end
