require 'spec_helper'
require_relative '../../lib/puppetclassify'

describe Environments do
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

  describe "#get_environments" do
    let(:response_body) { response_body = "[{\"name\":\"production\"}]" }

    it "returns an Array of environments" do
      stub_request(:get, "#{@classifier_url}/v1/environments").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => response_body, :headers => {})
      expect(@puppetclassify.environments.get_environments).to be_an_instance_of Array
    end
  end

  describe "#get_environment" do
    let(:response_body) { response_body = "{\"name\":\"production\"}" }
    let(:name) { name = 'production' }

    it "returns a Hash of the specified environment" do
      stub_request(:get, "#{@classifier_url}/v1/environments/#{name}").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => response_body, :headers => {})
      expect(@puppetclassify.environments.get_environment(name)).to be_an_instance_of Hash
    end
  end

  describe "#create_environment" do
    let(:name) { name = 'development' }

    it "creates an environment given a name" do
      stub_request(:put, "#{@classifier_url}/v1/environments/#{name}").
                 with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
                 to_return(:status => 201, :body => "", :headers => {})
      expect(@puppetclassify.environments.create_environment(name)).to be_nil
    end
  end
end
