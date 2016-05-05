# encoding: UTF-8

# Объектная модель управления железнодорожным транспортом.
# Крайняя версия от 02 мая 2016. Упрощенная.

# ======================== Train ============================
class Train

  attr_reader :train_num, :train_kind, :vagon_qnty, :cur_station, :route_name, :list_of_vagons

  @@list_of_trains = {}

  def self.list_of_trains
    @@list_of_trains
  end
  
  def initialize(train_num, train_kind, route_name)
    @train_kind = train_kind
    @train_num = train_num.to_s
    @vagon_qnty = 0
    @train_move = false
    @speed = 0
    @list_of_vagons = []
    if Route.list_of_routes.include?(route_name)
      @route_name = route_name
      @stations_on_route = Route.list_of_routes[route_name]
      @cur_station = @stations_on_route[0]
    end
    @@list_of_trains[@train_num] = { train_kind: @train_kind, vag_qnty: @vagon_qnty, 
          route_name: @route_name, cur_station: @cur_station, vagons: @list_of_vagons }
    set_train_at_init_station
  end

  # Это публичный метод для дополнения состава заданным количестовм вагонов. Он использует private 
  # метод повагонного дополнения
  def make_longer_with(qnty)
    qnty.times do 
      self.vagon_add
    end
    @@list_of_trains[@train_num][:vag_qnty] = @vagon_qnty
    @@list_of_trains[@train_num][:vagons] = @list_of_vagons
    print "Количество вагонов в составе #{@train_kind} поезда № #{@train_num} : #{@vagon_qnty} : #{list_of_vagons}\n"
    @vagon_qnty
  end

  # Это публичный метод для дополнения состава заданным количестовм вагонов. Он использует private 
  # метод повагонного дополнения
  def make_shorter_with(qnty)
    qnty.times do 
      self.vagon_ded
    end
    @@list_of_trains[@train_num][:vag_qnty] = @vagon_qnty
    @@list_of_trains[@train_num][:vagons] = @list_of_vagons
    puts "Количество вагонов в составе #{@train_kind} поезда № #{@train_num} : #{@vagon_qnty}"
    @vagon_qnty
  end

  # Публичными методами departure & arriving поезд перемещается между станциями, указанными в маршруте,
  # набирая и сбрасывая скорость, а также формирует список оставшихся/прибывших поездов на станции
  def departure
    10.times { |n| self.speed_up  }
    Station.train_depart(@train_num, @cur_station)
  end

  def arriving
    ind = @stations_on_route.index(@cur_station)
    while @speed > 0 
      self.slow_down
    end
    @cur_station = @stations_on_route[ind + 1]
    @@list_of_trains[@train_num][:cur_station] = @cur_station
    Station.train_arrived(@train_num, @train_kind, @cur_station)
    if !@cur_station
      puts "Состав дальше не идет!! Конечная станция."
    else
      where?
    end
    
  end

  protected

  # Помещение поезда на начальной станции маршрута - это приватный метод, поскольку является частью более общего метоа
  def set_train_at_init_station
    train_kind = @@list_of_trains[@train_num][:train_kind]
    station_name = @@list_of_trains[@train_num][:cur_station]
    Station.list_of_stations[station_name][train_num] = train_kind
    where?
  end


  # Показывать предыдущую станцию, текущую, следующую, на основе маршрута. Часть более общего метода.
  def where?
    ind = @stations_on_route.index(@cur_station)
    puts "Поезд находится на станции #{@cur_station}. Предыдущая станция - #{@stations_on_route[ind - 1] if ind != 0}. Следующая станция - #{@stations_on_route[ind + 1]}."
  end
  
  
  # Это приватный метод повагонного дополнения состава поезда - как подметод формирования состава
  def vagon_add
    if @speed == 0
      @list_of_vagons << PassangerVagon.new if @train_kind == :pass
      @list_of_vagons << CargoVagon.new if @train_kind == :carg
      @vagon_qnty += 1
    end
  end

  # Это приватный метод повагонного сокращения состава поезда - как подметод формирования состава
  def vagon_ded
    if @speed == 0 && @vagon_qnty > 0
      @list_of_vagons.delete_at(-1)
      @vagon_qnty -= 1
    end
  end  

  # Это приватный метод постепенного разгона поезда - как часть метода отправления поезда
  def speed_up
    @speed += 10
    @train_move = true
  end

  # Это приватный метод постепенного торможенжения поезда - как часть метода прибытия поезда
  def slow_down
    @speed -= 10 if @speed > 0
    @train_move = false if @speed == 0
  end

end

# ================== PassangerTrain ============================
class PassangerTrain < Train
  def initialize(train_num, train_kind = :pass, route_name)
    super
  end 
end

# ================== CargoTrain ============================
class CargoTrain < Train
  def initialize(train_num, train_kind = :carg, route_name)
    super
  end
end
