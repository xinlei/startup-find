require 'net/http'
require 'json'

class StartupsController < ApplicationController
  def index
    query = params[:query]
    @data = {}
    if query == nil
      @companies = nil
      #@data = nil
    else
      @companies = nil
      @data = nil

      company = Crunchbase::Organization.get("facebook")
      puts company
      funding_rounds = company.funding_rounds

      unless funding_rounds == nil
        for a in funding_rounds
          funding_round = a.fetch
          #uuid = funding_round.permalink
          uuid = "b0e3eb999048d301089226cedab900a7"
          puts uuid
          user_key = "895c34e4aff75534f72ee3bc55e4a516"
          puts "http://api.crunchbase.com/v/2/funding-round/#{uuid}?user_key=#{user_key}"

          uri = URI("http://api.crunchbase.com/v/2/funding-round/#{uuid}?user_key=#{user_key}")
          res = Net::HTTP.get_response(uri)
          #puts res.body
          json = JSON.parse(res.body)

          puts json[:data].properties
        end
      end

      #companies = Crunchbase::Organization.find_all_by_query(query)
      #for company in companies
      #  funding_rounds = company.funding_rounds
      #  unless funding_rounds == nil
      #    for funding_round in funding_rounds
      #      puts funding_round.name
      #    end
      #  end
      #end
    end
  end
end
