require 'flightstats'

FlightStats.app_id = ENV["FLIGHTSTATS_ID"]
FlightStats.app_key = ENV["FLIGHTSTATS_KEY"]
FlightStats.logger = Rails.logger
