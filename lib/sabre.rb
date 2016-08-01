require 'httparty'
require 'json'

class Sabre
  BASE_URL = "https://api.sabre.com/v2"

  attr_accessor :originlocation, :fareinfo
  def initialize(data)
    @originlocation = data["OriginLocation"]
    @fareinfo = data["FareInfo"]
  end

  def self.find(origin, departure_date, return_date)
    # token = SacsRuby.client.fetch_token
    # data = HTTParty.post(BASE_URL + "/shop/flights/fares?origin=CLT&departuredate=2016-12-15&returndate=2016-12-25&maxfare=220").parsed_response
    data = SacsRuby::API::DestinationFinder.get(origin: origin, departuredate: departure_date, returndate: return_date) # add `token: token_string` if needed

    return self.new(data)
  end

end
