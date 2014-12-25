require 'net/http'
require 'json'

class StartupsController < ApplicationController
  def index
    @data = {}
  end

  def show
    query = params[:query]

    # Replace facebook with query
    startup = Crunchbase::Organization.get("facebook")

    if startup == nil
      # Display error message
    else
      funding_rounds = get_funding_rounds(query)
      for item in funding_rounds
        path = item["path"]
        funding_round = get_funding_round(path)

        puts funding_round["properties"]["series"]
        puts funding_round["properties"]["money_raised_usd"]
      end
    end
  end

  def get_funding_rounds(query)
    user_key = "895c34e4aff75534f72ee3bc55e4a516"
    uri = URI("http://api.crunchbase.com/v/2/organization/#{query}/funding_rounds?user_key=#{user_key}")
    res = Net::HTTP.get_response(uri)
    ret = JSON.parse(res.body)
    ret["data"]["items"]
  end

  def get_funding_round(path)
    user_key = "895c34e4aff75534f72ee3bc55e4a516"
    uri = URI("http://api.crunchbase.com/v/2/#{path}?user_key=#{user_key}")
    res = Net::HTTP.get_response(uri)
    ret = JSON.parse(res.body)
    ret["data"]
  end

  def sum_by_series(series, value, data)
    
  end

end
