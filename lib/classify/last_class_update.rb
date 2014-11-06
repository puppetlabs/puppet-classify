require 'puppet_https'

class LastClassUpdate
  def initialize(nc_api_url, puppet_https)
    @nc_api_url = nc_api_url
    @puppet_https = puppet_https
  end

  def get
    class_update_res = @puppet_https.get("#{@nc_api_url}/v1/last-class-update")

    JSON.parse(class_update_res.body)
  end
end
