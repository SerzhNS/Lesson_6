# ======================== Station ============================
class Station

  attr_reader :list_hosting_trains, :station_name

  @@list_of_stations = {}

  def self.list_of_stations
    @@list_of_stations
  end

  def initialize(station_name)
    @station_name = station_name
    @list_hosting_trains = []
    @@list_of_stations[station_name] = {}
  end

  # train_kind принимает значения 
  def list_trains_by_kind(train_kind)
    puts "Список поездов типа #{train_kind}, находящихся на станции #{@station_name} : #{@list_hosting_trains.rassoc(train_kind)}"
    @list_hosting_trains.rassoc(train_kind)
  end

  def train_arrived(train_num)
    @list_hosting_trains << train_num
    @@list_of_stations[@station_name] = @list_hosting_trains
  end

  def train_departed(train_num)
    @list_hosting_trains.delete(train_num)
    @@list_of_stations[@station_name] = @list_hosting_trains
  end
end
