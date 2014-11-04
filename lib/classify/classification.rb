require 'puppet_https'

class Classification
  def initialize(nc_api_url, puppet_https)
    @nc_api_url = nc_api_url
    @puppet_https = puppet_https
  end

  def get(name)
    class_res = @puppet_https.post("#{@nc_api_url}/v1/classified/nodes/#{name}")

    unless class_res.code.to_i == 200
      STDERR.puts "An error occured retreiving the classification of node #{name}: HTTP #{class_res.code} #{class_res.message}"
      STDERR.puts class_res.body
    else
      class_res.body
    end
  end

  def explain(name)
    class_res = @puppet_https.post("#{@nc_api_url}/v1/classified/nodes/#{name}/explanation")

    unless class_res.code.to_i == 200
      STDERR.puts "An error occured retreiving the classification explanation of node #{name}: HTTP #{class_res.code} #{class_res.message}"
      STDERR.puts class_res.body
    else
      class_res.body
    end
  end

end
