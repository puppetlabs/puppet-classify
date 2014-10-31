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
  end

  def get_groups
    group_res = @puppet_https.get("#{@nc_api_url}/v1/groups")
  end

  def create_group(group_info)
    if group_info['id']
      # HTTP PUT /v1/groups/:id
      res = @puppet_https.put("#{@nc_api_url}/v1/groups/#{group_id}", group_info.to_json)
    else
      # HTTP POST /v1/groups
      res = @puppet_https.post("#{@nc_api_url}/v1/groups", group_info.to_json)
    end
  end

  def update_group(group_info_delta)
    # HTTP POST /v1/groups/:id
    group_res = @puppet_https.post("#{@nc_api_url}/v1/groups/#{group_info_delta['id']}", group_info_delta.to_json)

    unless group_res.code.to_i == 200
      puts "Update Group failed: HTTP #{group_res.code} #{group_res.message}"
    end
  end

  def delete_group(group_id)
    group_res = @puppet_https.delete("#{@nc_api_url}/v1/groups/#{group_id}")
    if group_res.code.to_i != 204
      STDERR.puts "An error occured deleting the group: HTTP #{group_res.code} #{group_res.message}"
    end
  end
end
