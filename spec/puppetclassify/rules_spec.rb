require 'spec_helper'
require_relative '../../lib/puppetclassify'

describe Rules do
  before :each do
    @classifier_url = 'https://puppetmaster.local:4433/classifier-api'

    private_key_path    = "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem"
    certificate_path    = "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem"
    ca_certificate_path = "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem"

    auth_info = {
      "private_key_path"    => private_key_path,
      "certificate_path"    => certificate_path,
      "ca_certificate_path" => ca_certificate_path,
    }

    expect(File).to receive("exists?").with(certificate_path).and_return(true)
    expect(File).to receive("exists?").with(private_key_path).and_return(true)
    expect(File).to receive("exists?").with(ca_certificate_path).and_return(true)

    expect(File).to receive("read").with(certificate_path).and_return('a cert')
    expect(File).to receive("read").with(private_key_path).and_return('a key')
    expect(OpenSSL::X509::Certificate).to receive("new").with('a cert').and_return('a cert object')
    expect(OpenSSL::PKey::RSA).to receive("new").with('a key').and_return('a key object')

    @puppetclassify = PuppetClassify.new(@classifier_url, auth_info)
  end

  describe "#translate" do
    let(:rule) { rule = ["or",["=","name","puppetmaster.local"]] }
    let(:response_body) { response_body = "[\"or\",[\"=\",\"name\",\"puppetmaster.local\"]]" }

    it "gets an array of a translated rule" do
      stub_request(:post, "#{@classifier_url}/v1/rules/translate").
                 with(:body => rule.to_json,
                      :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
                 to_return(:status => 200, :body => response_body, :headers => {})
      expect(@puppetclassify.rules.translate(rule)).to be_an_instance_of Array
    end
  end
end
