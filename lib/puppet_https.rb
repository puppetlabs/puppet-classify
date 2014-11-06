require 'uri'
require 'net/https'

class PuppetHttps
  def initialize(settings)
    # Settings hash:
    #   - ca_certificate_path
    #   - certificate_path
    #   - private_key_path
    #

    @settings = settings
  end

  def make_ssl_request(url, req)
    connection = Net::HTTP.new(url.host, url.port)
    connection.set_debug_output $stderr
    connection.use_ssl = true
    connection.ssl_version = :TLSv1

    connection.verify_mode = OpenSSL::SSL::VERIFY_PEER
    ca_file = @settings['ca_certificate_path']
    certpath = @settings['certificate_path']
    pkey_path = @settings['private_key_path']

    if File.exists?(ca_file)
      connection.ca_file = ca_file
    end

    if File.exists?(certpath)
      connection.cert = OpenSSL::X509::Certificate.new(File.read(certpath))
    end

    if File.exists?(pkey_path)
      connection.key = OpenSSL::PKey::RSA.new(File.read(pkey_path))
    end

    connection.start { |http| http.request(req) }
  end

  def put(url, request_body=nil)
    url = URI.parse(url)
    req = Net::HTTP::Put.new(url.path)
    req.content_type = 'application/json'

    unless request_body.nil?
      req.body = request_body
    end

    res = make_ssl_request(url, req)
  end

  def get(url)
    url = URI.parse(url)
    accept = 'application/json'
    req = Net::HTTP::Get.new("#{url.path}?#{url.query}", "Accept" => accept)
    res = make_ssl_request(url, req)
    res.error! unless res.code_type == Net::HTTPOK

    res
  end

  def post(url, request_body=nil)
    url = URI.parse(url)

    request = Net::HTTP::Post.new(url.request_uri)
    request.content_type = 'application/json'

    unless request_body.nil?
      request.body = request_body
    end

    res = make_ssl_request(url, request)
    res
  end

  def delete(url)
    url = URI.parse(url)

    request = Net::HTTP::Delete.new(url.request_uri)
    request.content_type = 'application/json'

    res = make_ssl_request(url, request)
    res
  end
end
