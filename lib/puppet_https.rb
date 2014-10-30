require 'uri'
require 'net/https'

class PuppetHttps
  def self.make_ssl_request(url, req)
    connection = Net::HTTP.new(url.host, url.port)
    connection.use_ssl = true

    connection.verify_mode = OpenSSL::SSL::VERIFY_PEER
    ca_file = File.join(Rails.root, SETTINGS.ca_certificate_path)
    certpath = File.join(Rails.root, SETTINGS.certificate_path)
    pkey_path = File.join(Rails.root, SETTINGS.private_key_path)

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

  def self.put(url, data)
    url = URI.parse(url)
    req = Net::HTTP::Put.new(url.path)
    req.content_type = 'application/json'
    req.body = data
    res = make_ssl_request(url, req)
    res.error! unless res.code_type == Net::HTTPOK
  end

  def self.get(url, accept)
    url = URI.parse(url)
    req = Net::HTTP::Get.new("#{url.path}?#{url.query}", "Accept" => accept)
    res = make_ssl_request(url, req, authenticate)
    res.error! unless res.code_type == Net::HTTPOK
    res.body
  end

  def self.post(url, request_body)
    url = URI.parse(url)

    request = Net::HTTP::Post.new(url.request_uri)
    request.content_type = 'application/json'

    unless request_body.nil?
      request.body = request_body
    end

    res = make_ssl_request(url, request)
    res
  end

  def self.delete(url)
    url = URI.parse(url)

    request = Net::HTTP::Delete.new(url.request_uri)
    request.content_type = 'application/json'

    res = make_ssl_request(url, request)
    res
  end
end
