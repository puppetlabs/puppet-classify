require 'puppet_https'

class Nodes
  def initialize(nc_api_url, puppet_https)
    @puppet_https = puppet_https
    @nc_api_url = nc_api_url
  end

  def get_nodes
    node_res = @puppet_https.get("#{@nc_api_url}/v1/nodes")
    JSON.parse(node_res.body)
  end

  def get_node(node_name)
    node_res = @puppet_https.get("#{@nc_api_url}/v1/nodes/#{node_name}")
    JSON.parse(node_res.body)
  end
end
