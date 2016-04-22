require 'puppet_https'
require 'json'

class Groups
  def initialize(nc_api_url, puppet_https)
    @nc_api_url = nc_api_url
    @puppet_https = puppet_https
  end

  def get_group(group_id)
    # HTTP GET
    group_res = @puppet_https.get("#{@nc_api_url}/v1/groups/#{group_id}")
    unless group_res.code.to_i != 200
      JSON.parse(group_res.body)
    else
      STDERR.puts "An error occured with your request: HTTP #{group_res.code} #{group_res.message}"
      STDERR.puts group_res.body
    end
  end

  def get_group_id(group_name)
    groups_res = @puppet_https.get("#{@nc_api_url}/v1/groups")

    unless groups_res.code.to_i != 200
      groups = JSON.parse(groups_res.body)
    else
      STDERR.puts "An error occured with your request: HTTP #{groups_res.code} #{groups_res.message}"
      STDERR.puts groups_res.body
    end

    group_info = groups.find { |group| group['name'] == group_name }

    if group_info.nil?
      STDERR.puts "Could not find group with the name #{group_name}"
    else
      group_info['id']
    end
  end

  def get_groups
    group_res = @puppet_https.get("#{@nc_api_url}/v1/groups")
    JSON.parse(group_res.body)
  end

  def create_group(group_info)
    if group_info['id']
      # HTTP PUT /v1/groups/:id
      res = @puppet_https.put("#{@nc_api_url}/v1/groups/#{group_info['id']}", group_info.to_json)
    else
      # HTTP POST /v1/groups
      res = @puppet_https.post("#{@nc_api_url}/v1/groups", group_info.to_json)
    end

    if res.code.to_i >= 400
      STDERR.puts "An error occured creating the group: HTTP #{res.code} #{res.message}"
      STDERR.puts res.body
    else
      unless group_info['id']
        res['location'].split("/")[-1]
      else
        group_info['id']
      end
    end
  end

  def update_group(group_info_delta)
    # HTTP POST /v1/groups/:id
    group_res = @puppet_https.post("#{@nc_api_url}/v1/groups/#{group_info_delta['id']}", group_info_delta.to_json)

    unless group_res.code.to_i == 200
      STDERR.puts "Update Group failed: HTTP #{group_res.code} #{group_res.message}"
      STDERR.puts group_res.body
    end
  end

  def delete_group(group_id)
    group_res = @puppet_https.delete("#{@nc_api_url}/v1/groups/#{group_id}")
    if group_res.code.to_i != 204
      STDERR.puts "An error occured deleting the group: HTTP #{group_res.code} #{group_res.message}"
      STDERR.puts group_res.body
    end
  end

  def pin_nodes(group_id, node_hash)
    request_body = {}
    request_body["nodes"] = node_hash # expects node_hash to be array, i.e. ["foo", "bar", "baz"]
    group_response = @puppet_https.post("#{@nc_api_url}/v1/groups/#{group_id}/pin", request_body.to_json)

    unless group_response.code.to_i == 204
      STDERR.puts "An error occured pinning nodes the group: HTTP #{group_response.code} #{group_response.message}"
      STDERR.puts group_response.body
    end
  end

  def unpin_nodes(group_id, node_hash)
    request_body = {}
    request_body["nodes"] = node_hash # expects node_hash to be array, i.e. ["foo", "bar", "baz"]
    group_response = @puppet_https.post("#{@nc_api_url}/v1/groups/#{group_id}/unpin", request_body.to_json)

    unless group_response.code.to_i == 204
      STDERR.puts "An error occured unpinning nodes the group: HTTP #{group_response.code} #{group_response.message}"
      STDERR.puts group_response.body
    end
  end
end
