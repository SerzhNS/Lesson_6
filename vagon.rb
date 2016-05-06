# encoding: UTF-8

# ===================== Vagon ====================
class Vagon

	@@total_num = 0

	attr_reader :num, :type

	def initialize
		@@total_num += 1
		@type = itself.class		# Тип вагона будем определять по значению класса его объекта
		@num = @@total_num
	end
end
