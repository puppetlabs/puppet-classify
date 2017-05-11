require 'uri'
require 'net/https'

class PuppetHttps
  def initialize(settings)
    # Settings hash:
    #   - ca_certificate_path
    #   - certificate_path (optional)
    #   - private_key_path (optional)
    #   - read_timeout (optional)
    #   - token_path (default: $HOME/.puppetlabs/token)
    #   - token (optional, takes precedence over token_path)
    #
    #   token auth takes precedence over cert auth (in the case that both methods are provided)

    default_token_path = File.join(ENV['HOME'], '.puppetlabs', 'token')

    cert_path = settings['certificate_path']
    pkey_path = settings['private_key_path']

    @ca_file      = settings['ca_certificate_path'] if File.exists?(settings['ca_certificate_path'])
    @read_timeout = settings['read_timeout'] || 90 # A default timeout value in seconds

    @auth_method = case
      when (settings['token'] or settings['token_path'])
        'token'
      when (cert_path and pkey_path)
        'cert'
      when File.exists?(default_token_path)
        'token'
      else
        nil
      end

    unless @auth_method
      raise RuntimeError "No authentication methods available."
    end

    case @auth_method
    when 'token'
      @token      = settings['token']
      @token_path = (settings['token_path'] || default_token_path) unless @token
    when 'cert'
      if File.exists?(cert_path) and File.exists?(pkey_path)
        @cert = OpenSSL::X509::Certificate.new(File.read(cert_path))
        @key  = OpenSSL::PKey::RSA.new(File.read(pkey_path))
      else
        raise RuntimeError "Certificate auth requested but certificate or private key cannot be found."
      end
    end

  end

  def make_ssl_request(url, req)
    connection = Net::HTTP.new(url.host, url.port)

    # connection.set_debug_output $stderr

    connection.use_ssl      = true
    connection.ssl_version  = :TLSv1
    connection.verify_mode  = OpenSSL::SSL::VERIFY_PEER
    connection.ca_file      = @ca_file if @ca_file
    connection.read_timeout = @read_timeout

    if @auth_method == 'cert'
      connection.cert = @cert
      connection.key  = @key
    end

    connection.start { |http| http.request(req) }
  end

  def put(url, request_body=nil)
    url = URI.parse(url)
    req = Net::HTTP::Put.new(url.path, self.auth_header)
    req.content_type = 'application/json'

    unless request_body.nil?
      req.body = request_body
    end

    res = make_ssl_request(url, req)
  end

  def get(url)
    url = URI.parse(url)
    accept = 'application/json'
    req = Net::HTTP::Get.new("#{url.path}?#{url.query}", {"Accept" => accept}.merge(self.auth_header))
    res = make_ssl_request(url, req)
    res
  end

  def post(url, request_body=nil)
    url = URI.parse(url)

    request = Net::HTTP::Post.new(url.request_uri, self.auth_header)
    request.content_type = 'application/json'

    unless request_body.nil?
      request.body = request_body
    end

    res = make_ssl_request(url, request)
    res
  end

  def delete(url)
    url = URI.parse(url)

    request = Net::HTTP::Delete.new(url.request_uri, self.auth_header)
    request.content_type = 'application/json'

    res = make_ssl_request(url, request)
    res
  end

  #private

  def token
    return @token if @token
    if @token_path and File.exists?(@token_path)
      @token = File.read(@token_path)
      return @token
    end
    return nil
  end

  def auth_header
    token  = self.token
    header = token ? {"X-Authentication" => token} : {}
  end
end
