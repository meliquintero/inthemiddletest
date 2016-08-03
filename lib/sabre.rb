class Sabre

  attr_accessor :originlocation, :fareinfo
  def initialize(data)
    @originlocation = data["OriginLocation"]
    @fareinfo = data["FareInfo"]
  end


  def self.add_sum_prices(sabre1, sabre2)
    hash = {}
    sabre1.fareinfo.each do |destination|
      hash[destination["DestinationLocation"]] = destination['LowestFare']["Fare"]
    end

    sabre2.fareinfo.each do |destination|
      hash[destination["DestinationLocation"]] += destination['LowestFare']["Fare"]
    end

    sabre2.fareinfo.each do |destination|
      destination['SumPrices'] = hash[destination["DestinationLocation"]]
    end

    sabre1.fareinfo.each do |destination|
      destination['SumPrices'] = hash[destination["DestinationLocation"]]
    end

    sabre2.fareinfo = sabre1.fareinfo.sort_by { |destination| destination['SumPrices'] }
    sabre1.fareinfo = sabre1.fareinfo.sort_by { |destination| destination['SumPrices'] }

    return sabre1, sabre2
  end

  def self.find(origin, departure_date, return_date)
    data = SacsRuby::API::DestinationFinder.get(origin: origin, departuredate: departure_date, returndate: return_date)
    return self.new(data)
  end

  def self.top_destinations
    data = SacsRuby::API::TopDestinations.get(origin: "SEA", topdestinations: 10)
    return data
  end

  def self.airport_codes(sabre)
    air = sabre.fareinfo.map do |one_dest|
     one_dest["DestinationLocation"]
    end
    return air
  end

  def self.geo_code (sabre)
    sabre.fareinfo.each do |destination|
      airline_info = SacsRuby::API::AirlineLookup.get(airlinecode: destination['LowestFare']['AirlineCodes'].first)
      destination['AirlineName'] = airline_info['AirlineInfo'].first['BussinesName']

      geo = SacsRuby::API::GeoCode.get(payload:
      [{
        'GeoCodeRQ' => {
          'PlaceById' => {
            'Id' => destination["DestinationLocation"],
            'BrowseCategory' => {
              'name' => "AIR"
            }
          }
        }
      }].to_json)
      destination['AirportName'] = geo["Results"].first["GeoCodeRS"]['Place'].first['Name']
      destination['City'] = geo["Results"].first["GeoCodeRS"]['Place'].first['City']
      destination['State'] = geo["Results"].first["GeoCodeRS"]['Place'].first['State']
      destination['Country'] = geo["Results"].first["GeoCodeRS"]['Place'].first['Country']
    end
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
    array_one = self.airport_codes(one)
    array_two = self.airport_codes(two)

    array = array_one & array_two

    one = self.clean(array, one)
    two = self.clean(array, two)

    self.geo_code(one)
    self.geo_code(two)


    return self.add_sum_prices(one, two)

  end

  def self.matching_destinations (origin_one, origin_two, departure_date, return_date)
    origin_one = self.find(origin_one, departure_date, return_date)
    origin_two = self.find(origin_two, departure_date, return_date)

    return self.find_commun(origin_one, origin_two)
  end


end
