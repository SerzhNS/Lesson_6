# encodifindng: UTF-8


# Объектная модель управления железнодорожным транспортом.
# Крайняя версия от 02 мая 2016. Упрощенная.

# ======================== Train ============================
# => Важно. В новой редакции откажемся от ведения списка объектов внутри класса.
# Учет всех объектов будем вести уровнем иерархии выше. Но внутри объектов данного 
# класса нужно вести учет всех входящих в него ОБЪЕКТОВ, например: вагонов, 
# принадлежащих поезду.
# Учет взаимодействия объектов, например: поездов Х станций Х маршрутов будем также
# вести уровнем выше спецификации данного класса. Это должно упростить "картину мира".  

class Train

  include Manufacturer
  include InstanceCounter
 
  attr_reader :train_num, :list_of_vagons
  attr_accessor :cur_station, :route_name, :speed, :stations_on_route

  @@list_of_trains = {}
  
  def initialize(train_num, manufacturer = "TVZ")
    @train_num = train_num.to_s
    @speed = 0
    self.man_name = manufacturer
    @list_of_vagons = []
    @@list_of_trains[train_num] = itself
    register_instance
  end

  class << self
    def find(train_num)
      @@list_of_trains[train_num]
    end
    
  end

  # Это публичный метод для дополнения состава заданным количестовм вагонов. Он использует private 
  # метод повагонного дополнения
  def make_longer_with(qnty)
    qnty.times do
      if self.class == PassangerTrain
        vagon = PassangerVagon.new
      else
        vagon = CargoVagon.new
      end 
      vagon_add(vagon)
    end
    puts "Количество вагонов в составе #{self.class} поезда № #{@train_num} увеличено до #{@list_of_vagons.count}"
    puts "Список вагонов : #{@list_of_vagons}"
  end

  # Это публичный метод для дополнения состава заданным количестовм вагонов. Он использует private 
  # метод повагонного дополнения
  def make_shorter_with(qnty)
    qnty.times do 
      self.vagon_ded
    end
    puts "Количество вагонов в составе #{self.class} поезда № #{@train_num} уменьшено до #{@list_of_vagons.count}"
  end

  # Публичными методами departure & arriving поезд перемещается между станциями, указанными в маршруте,
  # набирая и сбрасывая скорость, а также формирует список оставшихся/прибывших поездов на станции
  # station передается как объект, к которому будем применять нужные методы этого класса.
  def departure(station)
    10.times { self.speed_up }
    station.train_departed(self)
    puts "Поезд отправляется со станции #{station.station_name}"
  end

  def arriving(station)
    while @speed > 0 
      self.slow_down
    end
    station.train_arrived(self)
    @cur_station = station.station_name
    puts "Поезд прибывает на станцию #{station.station_name}"
  end

  # Помещение поезда на начальной станции маршрута - это приватный метод, поскольку является частью более общего метоа
  def set_train_at_init_station(station)
    station.train_arrived(self)
    where?
  end

  # Это публичный метод повагонного дополнения состава поезда - как подметод формирования состава
  def vagon_add(vagon)
    vagon_type = vagon.class.to_s.split("Vagon")
    train_type = self.class.to_s.split("Train")
    @list_of_vagons << vagon if @speed == 0 && vagon_type == train_type
  end



  protected


  # Показывать предыдущую станцию, текущую, следующую, на основе маршрута. Часть более общего метода.
  def where?
    ind = @stations_on_route.index(@cur_station)
    puts "Поезд находится на станции #{@cur_station}." # Предыдущая станция - #{@stations_on_route[ind - 1] if ind != 0}. Следующая станция - #{@stations_on_route[ind + 1]}."
  end
  
  # Это приватный метод повагонного сокращения состава поезда - как подметод формирования состава
  def vagon_ded
    if @speed == 0 && @list_of_vagons.count > 0
      @list_of_vagons.delete_at(-1)
    end
  end  

  # Это приватный метод постепенного разгона поезда - как часть метода отправления поезда
  def speed_up
    @speed += 10
  end

  # Это приватный метод постепенного торможенжения поезда - как часть метода прибытия поезда
  def slow_down
    @speed -= 10 if @speed > 0
  end
end
