
# ======================== Station ============================
class Station

  include InstanceCounter

  attr_accessor :list_hosting_trains
  attr_reader :station_name

  @@list_of_stations_as_objects = {}

  def self.all
    @@list_of_stations_as_objects
  end

  def initialize(station_name)
    register_instance
    @station_name = station_name
    @list_hosting_trains = []
    @@list_of_stations_as_objects[station_name] = self
  end

  # train_kind принимает значения 
  def list_trains_by_kind(train_kind)
    puts "Список поездов типа #{train_kind}, находящихся на станции #{@station_name} : #{@list_hosting_trains.rassoc(train_kind)}"
    self.list_hosting_trains.each { |e| puts e.train_num if e.class == train_kind  }
  end

  def train_arrived(train) 
    self.list_hosting_trains << train         # Храним сам объект
   end

  def train_departed(train)
    self.list_hosting_trains.delete(train)
  end
end
