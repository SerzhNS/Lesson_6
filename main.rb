
# encodung: UTF-8

# => Обеспечить через текстовый (строчный) 
require_relative "manufacturer.rb"
require_relative "instancecounter.rb"

require_relative "vagon.rb"
require_relative "route.rb"
require_relative "station.rb"
require_relative "train.rb"
require_relative "passangertrain.rb"
require_relative "cargotrain.rb"
require_relative "passangervagon.rb"
require_relative "cargovagon.rb"

instruction = ["1. Создание станций и маршрутов", "2. Создание поездов", "3. Добавление вагонов к поезду", 
  "4. Отцепление вагонов от поезда", "5. Перемещение поезда по станциям маршрута", "6. Просмотр списка станций и списка поездов на станциях"]
puts "Выберите номер операции для исполнения. Пустой ввод будет означать завершение всех операций."
puts (instruction)

trains = {}
stations = {}
routes ={}

loop do
  operation = gets.chomp.to_i
  case (operation)
    when 1 then
      # => 1. Создание станций и маршрутов
      puts "Необходимо задать, как минимум, две станции. По завершении нажмте пустой ввод."
      station_qnty = 0
      station_name = "_"
      until station_name == "" && station_qnty >= 2
        station_name = gets.chomp
        break if station_name == "" && station_qnty >= 2
        if station_name != "" 
          stations[station_name] = Station.new(station_name)
          station_qnty += 1 
        end
      end
      puts "Вы задали следующий список станций: #{stations}.
      Введите название маршрута и две станции из этого списка, которые зададут маршрут движения поезда."
      route_name ="__"
      until route_name ==""
        route_name = gets.chomp
        break if route_name == ""
        route_start = gets.chomp
        route_end = gets.chomp
        rt = Route.new(route_name, route_start, route_end)
        routes[route_name] = {rt => {}}
        routes[route_name][:route_stations] = rt.list_of_route_stations
      end
    when 2 then
      # => 2. Создание поездов
      puts "Теперь необходимо сформировать состав/ы."
      entry_end = false
      until entry_end
        puts "Введите название заданного ранее маршрута, номер поезда, тип состава = pass или = cargo, количество вагонов в составе."
        # предполагается, что оператор ошибок ввода не делает
        route_name = gets.chomp
        if route_name != ""
          train_num = gets.chomp.to_s
          train_kind = gets.chomp
          if train_kind == "pass"
            tr = PassangerTrain.new(train_num)
          else
            tr = CargoTrain.new(train_num)
          end	
          vag_qnty = gets.chomp.to_i
          tr.make_longer_with(vag_qnty)
          tr.route_name = route_name
          # => Привязка поезда к начальной точке маршрута
          tr.cur_station = routes[route_name][:route_stations][0]
          tr.stations_on_route = routes[route_name][:route_stations]
          station = stations[tr.cur_station]
          tr.set_train_at_init_station(station)
          trains[train_num] = tr
        else
          entry_end = true
          break
        end
      end
    when 3 then
      # => 3. Добавление вагонов к поезду
      puts "Если Вы хотите добавить вагонов к поезду, то введите его номер и количество добавляемых вагонов."
      train_num = gets.chomp.to_s
      if train_num != ""
        tr = trains[train_num]
        vag_qnty = gets.chomp.to_i
        tr.make_longer_with(vag_qnty)	
      end
    when 4 then
      # => 4. Отцепление вагонов от поезда
      puts "Если Вы хотите отцепить ряд вагонов от поезда, то введите его номер и количество отцепляемых вагонов."
      train_num = gets.chomp.to_s
      if train_num != ""
        tr = trains[train_num]
        vag_qnty = gets.chomp.to_i
        tr.make_shorter_with(vag_qnty)	
      end
    when 5 then
      # => 5. Перемещение поезда по станциям маршрута
      # => !!! При создании поезда он автоматически помещается на начальную станцию маршрута методом set_train_at_init_station.
      puts "Если вы хотите перемещать поезда по их маршрутам, то введите номер/а поезда/ов для перемещения каждого до следующей станции."
      entry_end = false
      until entry_end
        train_num = gets.chomp.to_s
        if train_num != ""
          tr = trains[train_num]
          ind = tr.stations_on_route.index(tr.cur_station)
          if ind < tr.stations_on_route.count
            cur_station = stations[tr.cur_station]
            tr.departure(cur_station)
            if ind < tr.stations_on_route.count
              flw_station = tr.stations_on_route[ind+1]
              tr.arriving(stations[flw_station]) if flw_station != nil 
            end
          else
            puts "Конец маршрута. Поезд дальше не идет. Покиньте вагоны поезда!"
          end  
        else
          entry_end = true
          break
        end
      end
    when 6 then
  # => 6. Просмотр списка станций и списка поездов на станциях
      puts "Список станций и принятых поездов: #{stations}"
      puts "Если Вы хотите посмотреть поезда на конкретной станции, то введите ее имя."
      station_name = gets.chomp.to_s
      if station_name != "" && stations.include?(station_name)
        st = stations[station_name]
        puts (st.list_hosting_trains)
      end
    else break # the loop
  end   # case
  puts "Введите номер следующей операции или сделайте пустой ввод - для выхода."
  puts (instruction)
end   # loop
