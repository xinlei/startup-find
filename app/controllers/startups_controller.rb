require 'net/http'
require 'json'

class StartupsController < ApplicationController

  # Display the search bar
  def index
    @data = {}
  end

  # Return the fund raised by series for a specific company
  # Return @data for the amount and @label for series type
  def show
    @query = params[:query]
    user_key = params[:api_key]
    if user_key == nil
      flash[:notice] = "No api key provided"
    else
      Crunchbase::API.key = user_key
      result = {}
      startup = Crunchbase::Organization.get(@query)
      funding_rounds = get_funding_rounds(@query, user_key)
      if startup == nil
        flash[:notice] = "Company not found"
      elsif funding_rounds == nil
        flash[:notice] = "#{@query} has no funding history on Crunchbase"
      else
        flash[:notice] = nil
        for item in funding_rounds
          path = item["path"]
          funding_round = get_funding_round(path, user_key)
          series = funding_round["properties"]["series"]
          value = funding_round["properties"]["money_raised_usd"]
          sum_by_series(series, value, result)
        end
        result = result.sort
        @data = []
        @label = []
        for n in result
          @data << n[1]
          @label << n[0]
        end
      end
    end
  end

  # Return the funding rounds for an organization
  def get_funding_rounds(query, user_key)
    uri = URI("http://api.crunchbase.com/v/2/organization/#{query}/funding_rounds?user_key=#{user_key}")
    res = Net::HTTP.get_response(uri)
    ret = JSON.parse(res.body)
    ret["data"]["items"]
  end

  # Return properties of the specific funding round
  def get_funding_round(path, user_key)
    uri = URI("http://api.crunchbase.com/v/2/#{path}?user_key=#{user_key}")
    res = Net::HTTP.get_response(uri)
    ret = JSON.parse(res.body)
    ret["data"]
  end

  # Sum the fund raised by series
  def sum_by_series(series, value, data)
    if series == nil
      series = "n/a"
    end
    series_symbol = series.to_s.capitalize
    unless value == nil
      value = value/1000000
      if data[series_symbol] == nil
        data[series_symbol] = value
      else
        data[series_symbol] = data[series_symbol] + value
      end
    end
  end

end
