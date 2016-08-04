require 'httparty'
require 'json'

class FlightsStats
  BASE_URL_STATS = 'https://api.flightstats.com/flex/flightstatus/rest/v2/json/flightsNear/'

  attr_accessor :kind

  def initialize(data)
    @kind = data
  end

  def self.find
    data = HTTParty.get(BASE_URL_STATS + "47.4502/-122.3088/25?appId=" + ENV["FLIGHTSTATS_ID"] + '&appKey=' + ENV["FLIGHTSTATS_KEY"] + "&maxFlights=100").parsed_response
    return self.new(data)
  end

end
