require 'puppet_https'

class Classes
  def initialize(nc_api_url, puppet_https)
    @nc_api_url = nc_api_url
    @puppet_https = puppet_https
  end

  def get_classes
    class_res = @puppet_https.get("#{@nc_api_url}/v1/classes")
    class_res.body
  end

  def get_environment_classes(environment)
    class_res = @puppet_https.get("#{@nc_api_url}/v1/environments/#{environment}/classes")
    class_res.body
  end

  def get_environment_class(environment, class_name)
    class_res = @puppet_https.get("#{@nc_api_url}/v1/environments/#{environment}/classes/#{class_name}")
    class_res.body
  end
end
