
# ======================== Route ============================
class Route

  include InstanceCounter
#  include Validation

  attr_reader :list_of_route_stations, :name

  def initialize(name, start_station, end_station)
    @name = name
    if Station.all.include?(start_station) && Station.all.include?(end_station)
      register_instance
      arr_all_stations = Station.all.keys
      init = arr_all_stations.index(start_station)
      fin = arr_all_stations.index(end_station)
      @list_of_route_stations = arr_all_stations[init..fin]
    end 
  end

  def append_station(ind, station_name)
    if Station.all[station_name]
      @list_of_route_stations.insert(ind, station_name)
    end
  end

  def delete_station(station_name)
    @list_of_route_stations.delete(station_name)
  end
end
