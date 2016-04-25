require 'puppet_https'
require 'json'

class Commands
  def initialize(nc_api_url, puppet_https)
    @puppet_https = puppet_https
    @nc_api_url = nc_api_url
  end

  def unpin_from_all(nodes)
    all_nodes = {}
    all_nodes['nodes'] = nodes

    response = @puppet_https.post("#{@nc_api_url}/v1/commands/unpin-from-all", all_nodes.to_json)

    unless response.code.to_i != 200
      nodez = JSON.parse(response.body)
    else
      STDERR.puts "An error occured with your request: HTTP #{response.code} #{response.message}"
      STDERR.puts response.body
    end
  end
end
