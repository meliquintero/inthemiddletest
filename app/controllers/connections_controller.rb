require "#{Rails.root}/lib/qpx.rb"
require "#{Rails.root}/lib/kayak.rb"
require "#{Rails.root}/lib/sabre.rb"

class ConnectionsController < ApplicationController

  # before_action :require_login, only: [:create, :show, :destroy]

  def index
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
    origin_one = params[:user_origin_one]
    origin_two = params[:user_origin_two]
    departure_date = params[:departure_date]
    return_date = params[:return_date]

    @sabre_one = Sabre.find(origin_one, departure_date, return_date)
    @sabre_two = Sabre.find(origin_two, departure_date, return_date)

    @kayak = Kayak.find(origin_one, departure_date)
      @data = QpxExpress.find(origin_one, origin_two, departure_date, return_date)

      # @user_origin_one = params[:user_origin_one]
      # @user_origin_two = params[:user_origin_two]

  end


end
