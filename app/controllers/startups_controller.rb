class StartupsController < ApplicationController

  require 'crunchbase-api'
  Crunchbase.user_key = '895c34e4aff75534f72ee3bc55e4a516'

  def index
    @companies = none
  end

  def show
    @companies
  end
end
