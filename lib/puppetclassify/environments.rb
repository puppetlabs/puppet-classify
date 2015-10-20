require 'puppet_https'

class Environments
  def initialize(nc_api_url, puppet_https)
    @nc_api_url = nc_api_url
    @puppet_https = puppet_https
  end

  def get_environments
    env_res = @puppet_https.get("#{@nc_api_url}/v1/environments")
    JSON.parse(env_res.body)
  end

  def get_environment(name)
    env_res = @puppet_https.get("#{@nc_api_url}/v1/environments/#{name}")
    JSON.parse(env_res.body)
  end

  def create_environment(name)
    env_res = @puppet_https.put("#{@nc_api_url}/v1/environments/#{name}")

    unless env_res.code.to_i == 201
      STDERR.puts "An error occured saving the environment: HTTP #{env_res.code} #{env_res.message}"
      STDERR.puts env_res.body
    end
  end
end
