# ======================== Route ============================
class Route

  @@list_of_routes = {}

  def self.list_of_routes
    @@list_of_routes
  end

  def initialize(route_name, start_station, end_station)
    @route_name = route_name
    if !Station.list_of_stations.include?(start_station)
      puts "Станции с названием #{start_station} нет с списке станций. Вначале инициализируйте станицю с эти именем. Создать маршрут нельзя."
    elsif !Station.list_of_stations.include?(end_station)
      puts "Станции с названием #{end_station} нет с списке станций. Вначале инициализируйте станицю с эти именем. Создать маршрут нельзя."
    else
      arr_all_stations = Station.list_of_stations.keys
      init = arr_all_stations.index(start_station)
      fin = arr_all_stations.index(end_station)
      @list_of_route_stations = arr_all_stations[init..fin]
      @@list_of_routes[route_name] = @list_of_route_stations
      puts "Создан маршрут c именем #{route_name}."
      list_stations
    end
  end

  private
  
  def append_station(ind, station_name)
    if Station.list_of_stations[station_name]
      @list_of_route_stations.insert(ind, station_name)
    end
  end

  def delete_station(station_name)
    @list_of_route_stations.delete(station_name)
  end

  def list_stations
    puts "Список всех станций на маршруте #{@route_name} : #{@list_of_route_stations}"
    @list_of_route_stations
  end
end
