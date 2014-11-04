require 'puppet_https'

class UpdateClasses
  def initialize(nc_api_url, puppet_https)
    @nc_api_url = nc_api_url
    @puppet_https = puppet_https
  end

  def update
    update_res = @puppet_https.post("#{@nc_api_url}/v1/update-classes")

    unless update_res.code.to_i == 201
      STDERR.puts "An error has occured during the update: HTTP #{update_res.code} #{update_res.message}"
      STDERR.puts update_res.body
    end
  end
end
