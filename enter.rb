class Name

	attr_reader :type, :name

	def initialize(type, name)
		@type = type
		@name = name
	end

	def valid?
		self.validate!
	rescue RuntimeError
		false 
	end

	def validate!
		case (self.type.to_s)
			when "Station"
				raise "Неправильный формат названия станции." if self.name !~ STATION_TEMPLATE
			when "Train"
				raise "Неправильный формат названия поезда." if self.name !~ TRAIN_TEMPLATE
			when "Route"
				raise "Неправильный формат названия маршрута." if self.name !~ ROUTE_TEMPLATE
			when "Kind"
				raise "Неправильный формат типа поезда." if self.name !~ TRAIN_TYPE_TEMPLATE
		end
		true
	end


	def enter
		case self.type
		when "Station"
	    3.times do |n|
	      puts "Введите название станции в нужном формате:"
	      name = gets.chomp
	      stn = Name.new("Station", name)
	      if stn.valid?
	      	return name
		      break 
	    	end
	      n += 1
	      raise "Неправильный 3-х кратный ввод названия станции." if n == 3
	    end

		when "Train"
	    3.times do |n|
	      puts "Введите название поезда в нужном формате:"
	      name = gets.chomp
	      trn = Name.new("Train", name)
	      if trn.valid?
		      return name
		      break 
	    	end
	      n += 1
	      raise "Неправильный 3-х кратный ввод названия поезда." if n == 3
	    end
		
		when "Route"
	    3.times do |n|
	      puts "Введите название маршрута в нужном формате:"
	      name = gets.chomp
	      rtn = Name.new("Route", name)
	      if rtn.valid?
		      return name
		      break 
	    	end
	      n += 1
	      raise "Неправильный 3-х кратный ввод названия маршрута." if n == 3
	    end

		when "Kind"
	    3.times do |n|
	      puts "Введите тип поезад в формате: pass или cargo"
	      name = gets.chomp
	      k = Name.new("Kind", name)
	      if k.valid?
		      return name
		      break 
	    	end
	      n += 1
	      raise "Неправильный 3-х кратный ввод типа поезда." if n == 3
	    end


		end
	end
	
end