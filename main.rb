# encodung: UTF-8

# => Обеспечить через текстовый (строчный) 

require_relative "vagon.rb"   
require_relative "route.rb"   
require_relative "station.rb" 
require_relative "train.rb"   

instruction = ["1. Создание станций и маршрутов", "2. Создание поездов", "3. Добавление вагонов к поезду", 
  "4. Отцепление вагонов от поезда", "5. Перемещение поезда по станциям маршрута", "6. Просмотр списка станций и списка поездов на станциях"]
puts "Выберите номер операции для исполнения. Пустой ввод будет означать завершение всех операций."
puts (instruction)

list_of_trains = {}
stations = {}

loop do
  operation = gets.chomp.to_i
  case (operation)
    when 1 then
      # => 1. Создание станций и маршрутов
      puts "Необходимо задать, как минимум, две станции. По завершении нажмте пустой ввод."
      station_name = "__"
      station_qnty = 0
      until station_name == "" && station_qnty >= 2
        station_name = gets.chomp
        break if station_name == "" && station_qnty >= 2
        if station_name != "" 
          stations[station_name] = Station.new(station_name)
          station_qnty += 1 
        end
      end
      puts "Вы задали следующий список станций: #{Station.list_of_stations}.
      Введите название маршрута и две станции из этого списка, которые зададут маршрут движения поезда."
      route_name ="__"
      until route_name ==""
        route_name = gets.chomp
        break if route_name == ""
        route_start = gets.chomp
        route_end = gets.chomp
        Route.new(route_name, route_start, route_end)
      end
    when 2 then
      # => 2. Создание поездов
      puts "Теперь необходимо сформировать состав/ы."
      entry_end = false
      until entry_end
        puts "Введите название маршрута, номер поезда, тип состава = пасс или = груз, количество вагонов в составе."
        # предполагается, что оператор ошибок ввода не делает
        route_name = gets.chomp
        if route_name != ""
          train_num = gets.chomp.to_s
          train_kind_in = gets.chomp
          if train_kind_in == "пасс"
            train_kind = :pass
          else
            train_kind = :carg
          end	
          vag_qnty = gets.chomp.to_i
          tr = Train.new(train_num, train_kind, route_name)
          tr.make_longer_with(vag_qnty)
          list_of_trains[train_num] = tr
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
        tr = list_of_trains[train_num]
        vag_qnty = gets.chomp.to_i
        tr.make_longer_with(vag_qnty)	
      end
    when 4 then
      # => 4. Отцепление вагонов от поезда
      puts "Если Вы хотите отцепить ряд вагонов от поезда, то введите его номер и количество отцепляемых вагонов."
      train_num = gets.chomp.to_s
      if train_num != ""
        tr = list_of_trains[train_num]
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
          tr = list_of_trains[train_num]
          tr.departure
          tr.arriving
        else
          entry_end = true
          break
        end
      end
    when 6 then
  # => 6. Просмотр списка станций и списка поездов на станциях
      puts "Список станций и принятых поездов: #{Station.list_of_stations}"
      puts "Если Вы хотите посмотреть поезда на конкретной станции, то введите ее имя."
      station_name = gets.chomp.to_s
      if station_name != "" && Station.list_of_stations.include?(station_name)
        st = stations[station_name]
        st.list_hosting_trains
      end
    else break # the loop
  end   # case
  puts "Введите номер следующей операции или сделайте пустой ввод - для выхода."
  puts (instruction)
end   # loop
