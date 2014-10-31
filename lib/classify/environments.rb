require 'puppet_https'

class Environments
  def initalize(nc_api_url, puppet_https)
    @nc_api_url = nc_api_url
    @puppet_https = puppet_https
  end

  def get_environments
    env_res = @puppet_https.get("#{@nc_api_url}/v1/environments")
  end

  def get_environment(name)
    env_res = @puppet_https.get("#{@nc_api_url}/v1/environments/#{name}")
  end

  def create_environment(name)
    env_res = @puppet_https.put("#{@nc_api_url}/v1/environments/#{name}")
  end
end
