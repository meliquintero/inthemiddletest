require 'ruby-prof'
require "#{Rails.root}/lib/qpx.rb"
require "#{Rails.root}/lib/kayak.rb"
require "#{Rails.root}/lib/sabre.rb"
require "#{Rails.root}/lib/flightstats.rb"
require "#{Rails.root}/lib/skyscanner.rb"

class ConnectionsController < ApplicationController

  # before_action :require_login, only: [:create, :show, :destroy]

  def index
    @top_destinations = Sabre.top_destinations
  end

  def new
  end

  def create
    @connection = Connection.new
    @connection.current_user_id = params[:current_user_id]
    @connection.origin_one = params[:origin_one]
    @connection.origin_two = params[:origin_two]

    @connection.save
    if @connection.save
      redirect_to connection_path(@connection.current_user_id)
    else
      render :index
    end
  end

  def show
    @connections = Connection.where(current_user_id: params[:id])
  end

  def destroy
    Connection.delete(params[:id])
    redirect_to connection_path(current_user.uid)
  end


  def search_result


  RubyProf.start
    origin_one = params[:user_origin_one]
    origin_two = params[:user_origin_two]
    departure_date = params[:departure_date]
    return_date = params[:return_date]

    @origin_one = params[:user_origin_one]

    # @kayak = Kayak.find(origin_one, departure_date)
    # @data = QpxExpress.find(origin_one, origin_two, departure_date, return_date)
    # @destinations = Sabre.matching_destinations(origin_one, origin_two, departure_date, return_date)

    # @neaby = FlightsStats.find
    # @quotes = Skyscanner.findquotes(origin_one, departure_date, return_date)

    # @routes = Skyscanner.findroutes(origin_one, departure_date, return_date)

    @session = Skyscanner.findflights(origin_one, origin_two, departure_date, return_date)
  result = RubyProf.stop

  printer = RubyProf::FlatPrinter.new(result)
  printer.print(STDOUT)



  end


end
