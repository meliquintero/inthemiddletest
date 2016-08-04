require 'httparty'
require 'json'

class Kayak
  BASE_URL_KAYAK = "https://www.kayak.com/h/explore/api"

  attr_accessor :kind
  def initialize(data)
    @kind = data
  end

  def self.find(origin, departure_date)
    data = HTTParty.post(BASE_URL_KAYAK + "?airport=jfk&depart=20161210").parsed_response

    return self.new(data)
  end

end
