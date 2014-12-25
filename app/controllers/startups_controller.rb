require 'net/http'
require 'json'

class StartupsController < ApplicationController
  def index
    @data = {}
  end

  def show
    query = params[:query]
    result = {}

    startup = Crunchbase::Organization.get(query)

    if startup == nil
      # Display error message
    else
      funding_rounds = get_funding_rounds(query)
      for item in funding_rounds
        path = item["path"]
        funding_round = get_funding_round(path)
        series = funding_round["properties"]["series"]
        value = funding_round["properties"]["money_raised_usd"]
        sum_by_series(series, value, result)
      end
    end
    puts result
    result = result.sort
    @query = query
    @data = []
    @label = []

    for n in result
      @data << n[1]
      @label << n[0]
    end

    puts result
    puts @data
  end

  def get_funding_rounds(query)
    user_key = ""
    uri = URI("http://api.crunchbase.com/v/2/organization/#{query}/funding_rounds?user_key=#{user_key}")
    res = Net::HTTP.get_response(uri)
    ret = JSON.parse(res.body)
    ret["data"]["items"]
  end

  def get_funding_round(path)
    user_key = ""
    uri = URI("http://api.crunchbase.com/v/2/#{path}?user_key=#{user_key}")
    res = Net::HTTP.get_response(uri)
    ret = JSON.parse(res.body)
    ret["data"]
  end

  def sum_by_series(series, value, data)
    if series == nil
      series = "n/a"
    end
    series_symbol = series.to_s.capitalize
    value = value/1000000
    if data[series_symbol] == nil
      data[series_symbol] = value
    else
      data[series_symbol] = data[series.to_s] + value
    end

  end

end
