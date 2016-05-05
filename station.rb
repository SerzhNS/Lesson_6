# ======================== Station ============================
class Station


  @@list_of_stations = {}

  def self.list_of_stations
    @@list_of_stations
  end

  def initialize(station_name)
    @station_name = station_name
    @list_of_all_hosting_trains = {}
    @@list_of_stations[station_name] = {}
  end


  def list_hosting_trains
    @list_of_all_hosting_trains = @@list_of_stations[@station_name]
    puts "Список поездов на станции #{@station_name} на данный момент : #{@list_of_all_hosting_trains}"
  end

  # train_kind принимает значения :pass или :carg
  def list_trains_by_kind(train_kind)
    @list_of_all_hosting_trains = @@list_of_stations[@station_name]
    puts "Список поездов типа #{train_kind}, находящихся на станции #{@station_name} : #{@list_of_all_hosting_trains.rassoc(train_kind)}"
    @list_of_all_hosting_trains.rassoc(train_kind)
  end

  private

  # Методы .train_arrived и .train_depart перенесены в private потому, что они стали частью методов 
  # отправления и/или прибытия поездов класса Train
  def self.train_arrived(train_num, train_kind, station_name)
    @@list_of_stations[station_name][train_num] = train_kind
  end


  def self.train_depart(train_num, station_name)
    @@list_of_stations[station_name].delete(train_num)
  end
end
