require 'httparty'
require 'json'

class Skyscanner
  BASE_URL_SKY_ROUTES = 'http://partners.api.skyscanner.net/apiservices/browseroutes/v1.0/'
  BASE_URL_SKY_QUOTES = 'http://partners.api.skyscanner.net/apiservices/browsequotes/v1.0/'
  BASE_URL_SKY_LOC = 'http://partners.api.skyscanner.net/apiservices/autosuggest/v1.0/'

  MARKET = "US"
  CURRENCY = "USD"
  LOCALE = "en-US"
  DESTINATION = "anywhere"

  attr_accessor :quotes

  def initialize(data)
    @quotes = data['Quotes']
  end

  def self.find_quotes(origin, departure_date, return_time)
    data = HTTParty.get(BASE_URL_SKY_QUOTES + MARKET + '/' + CURRENCY + '/' + LOCALE + '/' + origin + '/' + DESTINATION + '/' + departure_date + '/' + return_time + '?apiKey=' + ENV["SKYSCANNER_KEY"],
    headers: { 'Content-Type' => 'application/json' })
    .parsed_response
    return self.new(data)
  end

  def self.sky48_codes(skyscanner_object)
    codes = skyscanner_object.quotes.map do |one_dest|
     one_dest["OutboundLeg"]["DestinationId"]
    end
    return codes
  end

  def self.clean(array, skyscanner_object)
    skyscanner_object.quotes.each_with_index do |one_dest, index|
      unless array.include? one_dest["OutboundLeg"]["DestinationId"]
       skyscanner_object.quotes[index] = nil
      end
    end
    skyscanner_object.quotes = skyscanner_object.quotes.compact
    return skyscanner_object
  end

  def self.add_sum_prices(skyscanner1, skyscanner2)
    hash = {}
    skyscanner1.quotes.each do |destination|
      hash[destination["OutboundLeg"]["DestinationId"]] = destination['MinPrice']
    end

    skyscanner2.quotes.each do |destination|
      hash[destination["OutboundLeg"]["DestinationId"]] += destination['MinPrice']
    end

    skyscanner2.quotes.each do |destination|
      destination['SumPrices'] = hash[destination["OutboundLeg"]["DestinationId"]]
    end

    skyscanner1.quotes.each do |destination|
      destination['SumPrices'] = hash[destination["OutboundLeg"]["DestinationId"]]
    end

    skyscanner2.quotes = skyscanner2.quotes.sort_by { |destination| destination['SumPrices'] }
    skyscanner1.quotes = skyscanner1.quotes.sort_by { |destination| destination['SumPrices'] }

    final_array = [skyscanner1, skyscanner2]
    return final_array
  end

  def self.find_commun(one, two)
    array_one = self.sky48_codes(one)
    array_two = self.sky48_codes(two)

    array = array_one & array_two
    one = self.clean(array, one)
    two = self.clean(array, two)

    final_array = self.add_sum_prices(one, two)

    return final_array
  end

  def self.matching_destinations (origin_one, origin_two, departure_date, return_date)
    origin_one = self.find_quotes(origin_one, departure_date, return_date)
    origin_two = self.find_quotes(origin_two, departure_date, return_date)

    return self.find_commun(origin_one, origin_two)
  end

  def self.findlocation(location_id)
    data = HTTParty.get( BASE_URL_SKY_LOC + MARKET + '/' + CURRENCY + '/' + LOCALE + '/?id=' + location_id.to_s + '&apiKey=' + ENV["SKYSCANNER_KEY"],
    headers: { 'Content-Type' => 'application/json' })
      .parsed_response
      return data
  end


  def self.get_session_key(origin, desti, departure_date, return_time)
    session = HTTParty.post( 'http://partners.api.skyscanner.net/apiservices/pricing/v1.0',
    body: { "apiKey" => ENV["SKYSCANNER_KEY"],
      "locale" => LOCALE,
      "country" => "US",
      "currency" => CURRENCY,
      "originplace" => "96322-sky48",
      "destinationplace" => "81665-sky48",
      "Outbounddate" => departure_date,
      "Inbounddate" => return_time,
      "adults" => 1
    },
    headers: {
      #TRIED DELETETING FOLLOWING LINE
     'Content-Type' => 'application/x-www-form-urlencoded',
     'Accept' => 'application/json'
     })
     return session.headers['location']
   end

  def self.findflights(origin_one, destination, departure_date, return_time)

    url = self.get_session_key(origin_one, destination, departure_date, return_time)
    data = HTTParty.get(url + "?apiKey=" + ENV["SKYSCANNER_KEY"]).parsed_response


    return self.new(data)
  end




end
