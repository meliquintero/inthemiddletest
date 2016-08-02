class Sabre

  attr_accessor :originlocation, :fareinfo
  def initialize(data)
    @originlocation = data["OriginLocation"]
    @fareinfo = data["FareInfo"]
  end

  def self.find(origin, departure_date, return_date)
    data = SacsRuby::API::DestinationFinder.get(origin: origin, departuredate: departure_date, returndate: return_date)

    return self.new(data)
  end

  def self.top_destinations
    data = SacsRuby::API::TopDestinations.get(origin: "SEA", topdestinations: 10)
    return data
  end

  def self.airports(sabre)
    air = sabre.fareinfo.map do |one_dest|
     one_dest["DestinationLocation"]
    end
    return air
  end

  def self.clean(array, sabre)
    sabre.fareinfo.each_with_index do |one_dest, index|
      unless array.include? one_dest["DestinationLocation"]
       sabre.fareinfo[index] = nil
      end
    end
    sabre.fareinfo = sabre.fareinfo.compact
    return sabre
  end

  def self.find_commun(one, two)
    array_one = self.airports(one)
    array_two = self.airports(two)

    array = array_one & array_two

    one = self.clean(array, one)
    two = self.clean(array, two)

    return one, two
  end

  def self.matching_destinations (origin_one, origin_two, departure_date, return_date)
    origin_one = self.find(origin_one, departure_date, return_date)
    origin_two = self.find(origin_two, departure_date, return_date)

    return self.find_commun(origin_one, origin_two)
  end

end
