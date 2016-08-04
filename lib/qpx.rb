require 'httparty'
require 'json'

class QpxExpress
  BASE_URL_QPX = "https://www.googleapis.com/qpxExpress/v1/"
  KEY = ENV["GOOGLE_KEY"]
  attr_accessor :data
  def initialize(data)
    @data = data
  end

  def self.find(origin, destination, departure_date, date)
    data = HTTParty.post(BASE_URL_QPX + 'trips/search?key=' + KEY,
    :headers => {
      'Content-Type' => 'application/json'
    },

    :body => {
        "request": {
          "passengers": {
            "kind": "qpxexpress#passengerCounts",
            "adultCount": 1,

          },
          "slice": [
            {
              "kind": "qpxexpress#sliceInput",
              "origin": origin,
              "destination": destination,
              "date": departure_date
              }
          ],
          "maxPrice": "USD1400",
          "solutions": 2
        }
      }.to_json
    ).parsed_response
    return self.new(data)
  end

end
