require 'puppet_https'
require 'classify/groups'

class Classify
  def initialize(nc_api_url)
    if nc_api_url
      $nc_api_url = nc_api_url
    else
      $nc_api_url = 'https://puppetmaster.local:4433/classifier-api'
    end
  end

  def self.test
    puts 'Hello'
  end
end
