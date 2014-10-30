require 'puppet_https'

class Groups
  def initialize(group_info)
    # hash of group information
    @group_info = group_info
  end

  def self.get_group
    # HTTP GET
    group_res = PuppetHttps.get("#{$nc_api_url}/v1/group/#{@group_info['id']}")
  end

  def self.get_groups
    group_res = PuppetHttps.get("#{$nc_api_url}/v1/groups")
  end

  def self.create_group
    if @group_info['id']
      # HTTP PUT /v1/groups/:id
      res = PuppetHttps.put("#{$nc_api_url}/v1/groups/#{@group_info['id']}", @group_info)
    else
      # HTTP POST /v1/groups
      # get id in response and set @id (must follow redirects)
      res = PuppetHttps.post("#{$nc_api_url}/v1/groups", @group_info)
    end
  end

  def self.update_group(group_delta)
    # HTTP POST /v1/groups/:id
  end

  def self.delete_group
    group_res = PuppetHttps.delete("#{$nc_api_url}/v1/group/#{@group_info['id']}")
    if res.code.to_i != 204
      STDERR.puts "An error occured deleting the group: HTTP #{res.code} #{res.message}"
    end
  end
end
