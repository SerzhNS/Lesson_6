# encoding: UTF-8

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

  attr_reader :train_num, :train_kind
  attr_accessor :vagon_qnty, :cur_station, :route_name, :list_of_vagons, :speed, :stations_on_route
  
  def initialize(train_num)
    @train_num = train_num.to_s
    @speed = 0
    @train_kind = itself.class
    @list_of_vagons = []
  end

  # Это публичный метод для дополнения состава заданным количестовм вагонов. Он использует private 
  # метод повагонного дополнения
  def make_longer_with(qnty)
    qnty.times do
      if @train_kind == PassangerTrain
        vagon = PassangerVagon.new
      else
        vagon = CagroVagon.new
      end 
      vagon_add(vagon)
    end
    @vagon_qnty = @list_of_vagons.count
    puts "Количество вагонов в составе #{@train_kind} поезда № #{@train_num} увеличено до #{@vagon_qnty}"
    puts "Список вагонов : #{@list_of_vagons}"
  end

  # Это публичный метод для дополнения состава заданным количестовм вагонов. Он использует private 
  # метод повагонного дополнения
  def make_shorter_with(qnty)
    qnty.times do 
      self.vagon_ded
    end
    @vagon_qnty = @list_of_vagons.count
    puts "Количество вагонов в составе #{@train_kind} поезда № #{@train_num} уменьшено до #{@vagon_qnty}"
  end

  # Публичными методами departure & arriving поезд перемещается между станциями, указанными в маршруте,
  # набирая и сбрасывая скорость, а также формирует список оставшихся/прибывших поездов на станции
  # station передается как объект, к которому будем применять нужные методы этого класса.
  def departure(station)
    10.times { self.speed_up }
    station.train_departed(@train_num)
    @cur_station = station.station_name
    where?
  end

  def arriving(station)
    while @speed > 0 
      self.slow_down
    end
    station.train_arrived(@train_num)
    @cur_station = station.station_name
    where?
  end

  # Помещение поезда на начальной станции маршрута - это приватный метод, поскольку является частью более общего метоа
  def set_train_at_init_station(station)
    station.train_arrived(@train_num)
    where?
  end

  protected


  # Показывать предыдущую станцию, текущую, следующую, на основе маршрута. Часть более общего метода.
  def where?
    ind = @stations_on_route.index(@cur_station)
    puts "Поезд находится на станции #{@cur_station}." # Предыдущая станция - #{@stations_on_route[ind - 1] if ind != 0}. Следующая станция - #{@stations_on_route[ind + 1]}."
  end
  
  
  # Это приватный метод повагонного дополнения состава поезда - как подметод формирования состава
  def vagon_add(vagon)
    if @speed == 0
      @list_of_vagons << vagon 
    end
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
