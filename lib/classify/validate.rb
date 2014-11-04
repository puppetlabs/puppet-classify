require 'puppet_https'
require 'json'

class Validate
  def initialize(nc_api_url, puppet_https)
    @nc_api_url = nc_api_url
    @puppet_https = puppet_https
  end

  def validate_group(group_info)
    validate_res = @puppet_https.post("#{@nc_api_url}/v1/validate/group", group_info.to_json)

    unless validate_res.code.to_i == 200
      STDERR.puts "An error has occured validating the group: HTTP #{validate_res.code} #{validate_res.message}"
      STDERR.puts validate_res.body
    end
  end
end
