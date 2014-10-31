require 'puppet_https'

class ImportHierarchy
  def initialize(nc_api_url, puppet_https)
    @nc_api_url = nc_api_url
    @puppet_https = puppet_https
  end

  def import(group_hierarchy)
    import_res = @puppet_https.post("#{@nc_api_url}/v1/import-hierarchy", group_hierarchy.to_json)
  end
end
