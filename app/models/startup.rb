class Startup < ActiveRecord::Base

  def self.valid?(name)
    company = Crunchbase::Organization.get(name)
    if company == nil
      return false
    else
      return true
    end
  end

end
