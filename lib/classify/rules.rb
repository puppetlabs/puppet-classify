require 'puppet_https'
require 'json'

class Rules
  def initialize(nc_api_url, puppet_https)
    @nc_api_url = nc_api_url
    @puppet_https = puppet_https
  end

  def translate(rule)
    rules_res = @puppet_https.post("#{@nc_api_url}/v1/rules/translate", rule.to_json)

    unless rules_res.code.to_i == 200
      STDERR.puts "There was a problem with your rule: HTTP #{rules_res.code.to_i} #{rules_res.message}"
      STDERR.puts rules_res.body
    end
  end
end
