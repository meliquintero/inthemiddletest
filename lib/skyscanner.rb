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

  attr_accessor :kind

  def initialize(data)
    @kind = data
  end

  def self.findroutes(origin, departure_date, return_time)
    data = HTTParty.get(BASE_URL_SKY_ROUTES + MARKET + '/' + CURRENCY + '/' + LOCALE + '/' + origin + '/' + DESTINATION + '/' + departure_date + '/' + return_time + '?apiKey=' + ENV["SKYSCANNER_KEY"],
      headers: { 'Content-Type' => 'application/json' })
        .parsed_response
    return self.new(data)
  end

  def self.findquotes(origin, departure_date, return_time)
    data = HTTParty.get(BASE_URL_SKY_QUOTES + MARKET + '/' + CURRENCY + '/' + LOCALE + '/' + origin + '/' + DESTINATION + '/' + departure_date + '/' + return_time + '?apiKey=' + ENV["SKYSCANNER_KEY"],
      headers: { 'Content-Type' => 'application/json' })
        .parsed_response
    return self.new(data)
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
      "originplace" => origin + "-iata",
      "destinationplace" => desti + "-iata",
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

  def self.findflights(origin, desti, departure_date, return_time)
    url = self.get_session_key(origin, desti, departure_date, return_time)
    data = HTTParty.get(url + "?apiKey=" + ENV["SKYSCANNER_KEY"]).parsed_response


    return self.new(data)
  end




end
