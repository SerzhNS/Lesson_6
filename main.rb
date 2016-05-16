
# encodung: UTF-8

# => Обеспечить через текстовый (строчный) 
require_relative "manufacturer.rb"
require_relative "instancecounter_example.rb"
require_relative "enter.rb"
require_relative "validation.rb"
require_relative "vagon.rb"
require_relative "route.rb"
require_relative "station2.rb"
require_relative "train.rb"
require_relative "passangertrain.rb"
require_relative "cargotrain.rb"
require_relative "passangervagon.rb"
require_relative "cargovagon.rb"

include InstanceCounter
include Validation

instruction = ["1. Создание станций", "2. Создание маршрутов", "3. Создание поездов", "4. Добавление или отцепление вагонов к поезду", 
"5. Перемещение поезда по станциям маршрута", "6. Просмотр списка станций и списка поездов на станциях"]
puts "Выберите номер операции для исполнения. Пустой ввод будет означать завершение всех операций."
puts (instruction)

trains = {}
stations = {}
routes ={}

loop do
  operation = gets.chomp.to_i     # Ввести номер операции
  case (operation)
    when 1 then
      # => 1. Создание станций 
      puts "Необходимо через запятую задать, как минимум, две станции. По завершении нажмте пустой ввод."
      arr = gets.chomp.split(",")
      arr.each do |station_name|  
        stn = Name.new("Station", station_name)
        if !stn.valid?
          station_name = stn.enter
        end
        stations[station_name] = Station.new(station_name)
      end
      Station.list = stations
      puts "Вы задали следующий список станций: #{stations.keys}."

    when 2 then
      # => 2. Создание маршрутов
      puts "Введите через запятую название маршрута и две станции из этого списка, которые зададут маршрут движения поезда."
      5.times do |num|                  # До 5 маршрутов с проверкой корректности названий
        arr = gets.chomp.split(",")     # Проверяется: а) формат всех названий, б) наличие таких станций в общем списке
        rt_nm, in_st, fn_st = arr if arr.length == 3
        break if arr.empty? 
        # ----------- route ------------
        rt = Name.new("Route", rt_nm)
        if !rt.valid?
          rt_nm = rt.enter
        end
        # ----------- init station -----
        st = Name.new("Station", in_st)
        if !st.valid? 
          in_st = st.enter 
        end  
        in_st = st.enter unless Station.exist?(in_st)
        # ----------- fin station -------
        st = Name.new("Station", fn_st)
        if !st.valid?
          fn_st = st.enter
        end  
        fn_st = st.enter unless Station.exist?(fn_st)
        # --------------------------------
        rt = Route.new(rt_nm, in_st, fn_st)
        routes[rt_nm] = rt
        puts "Вы задали маршрут #{rt}, включающий станции #{rt.list_of_route_stations}."
      end
      Route.list = routes

    when 3 then
      # => 3. Создание поездов
      puts "Теперь необходимо сформировать состав/ы. До 5 составов, при необходимости."
      5.times do 
        puts "Введите через запятую название заданного ранее маршрута, номер поезда, тип состава = pass или = cargo, количество вагонов в составе."
        arr = gets.chomp.split(",")
        break if arr.empty?
        rt_nm, tr_n, tr_k, n_v = arr if arr.length == 4
        # ----------- is route correct and exists? ----
        rt = Name.new("Route", rt_nm)
        if !rt.valid?
          rt_nm = rt.enter
        end
        rt_nm = rt.enter unless Route.exist?(rt_nm)
        # ---------- is train name correct? -----------
        tr = Name.new("Train",tr_n)
        if !tr.valid?
          tr_n = tr.enter
        end
        trains[tr_n] = Train.new(tr_n)
        # --------- is train_kind correct? -----------
        if tr_k !~ Validation::TRAIN_TYPE_TEMPLATE
          k = Name.new("Kind", tr_k)
          tr_k = k.enter
        end
        # --------- vag qnty -------------------------
        if n_v !~ /\d{2}/
          n = Name.new("Num", n_v)
          n_v = n.enter.to_i
        end
        # --------- form train parameters ------------
        if tr_k == "pass"
          tr = PassangerTrain.new(tr_n)
        else
          tr = CargoTrain.new(tr_n)
        end
        tr.make_longer_with(n_v.to_i)
        tr.route_name = rt_nm
        rt = routes[rt_nm]
        tr.stations_on_route = rt.list_of_route_stations
        # => Привязка поезда к начальной точке маршрута
        tr.cur_station = tr.stations_on_route[0]
        station = stations[tr.cur_station]
        tr.set_train_at_init_station(station)
        trains[tr_n] = tr
      end
      Train.list = trains

    when 4 then
      # => 4. Добавление или отцепление вагонов к поезду, от поезда
      5.times do |n|  
        puts "Если Вы хотите добавить вагонов (+/-) к поезду, то введите через запятую его номер и количество добавляемых вагонов."
        arr = gets.chomp.split(",")
        break if arr.empty?
        tr_n, n_v = arr
        # ---------- is train name correct and exists? -----------
        tr = Name.new("Train",tr_n)
        if !tr.valid?
          tr_n = tr.enter
        end
        tr_n = tr.enter unless Train.exist?(tr_n)
        trains[tr_n] = Train.new(tr_n)
        # --------- vag qnty -------------------------
        if n_v !~ /\d{2}/
          n = Name.new("Num", n_v)
          n_v = n.enter.to_i
        end
        # ------------ form train length ------------
        tr = trains[tr_n]
        tr.make_longer_with(n_v) if n_v > 0   
        tr.make_shorter_with(-n_v) if n_v < 0   
      end

    when 5 then
      # => 5. Перемещение поезда по станциям маршрута
      # => !!! При создании поезда он автоматически помещается на начальную станцию маршрута методом set_train_at_init_station.
      puts "Если вы хотите перемещать поезда по их маршрутам, то введите номер/а поезда/ов для перемещения каждого до следующей станции."
      entry_end = false
      until entry_end
        tr_n = gets.chomp.to_s
        break if tr_n.empty?
        # ---------- is train name correct and exists? -----------
        tr = Name.new("Train",tr_n)
        if !tr.valid?
          tr_n = tr.enter
        end
        tr_n = tr.enter unless Train.exist?(tr_n)
        if trains.include?(tr_n)
          tr = trains[tr_n]
          ind = tr.stations_on_route.index(tr.cur_station)
          if ind < tr.stations_on_route.count - 1
            cur_station = stations[tr.cur_station]
            tr.departure(cur_station)
            flw_station = tr.stations_on_route[ind + 1]
            tr.arriving(stations[flw_station]) if flw_station != nil 
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
      puts (Station.instances)
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
