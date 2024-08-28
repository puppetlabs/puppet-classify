require 'spec_helper'
require_relative '../../lib/puppetclassify'

describe Validate do
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

    expect(File).to receive("exist?").with(certificate_path).and_return(true)
    expect(File).to receive("exist?").with(private_key_path).and_return(true)
    expect(File).to receive("exist?").with(ca_certificate_path).and_return(true)

    expect(File).to receive("read").with(certificate_path).and_return('a cert')
    expect(File).to receive("read").with(private_key_path).and_return('a key')
    expect(OpenSSL::X509::Certificate).to receive("new").with('a cert').and_return('a cert object')
    expect(OpenSSL::PKey::RSA).to receive("new").with('a key').and_return('a key object')

    @puppetclassify = PuppetClassify.new(@classifier_url, auth_info)
  end

  describe "#validate" do
    let(:group) { group = {"name"=>"testgroup", "description"=>"A cool group", "environment"=>"production", "parent"=>"00000000-0000-4000-8000-000000000000", "classes"=>{}} }

    it "sends a group to be validated" do
      stub_request(:post, "#{@classifier_url}/v1/validate/group").
                 with(:body => group,
                      :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
                 to_return(:status => 200, :body => "", :headers => {})
      expect(@puppetclassify.validate.validate_group(group)).to be_nil
    end
  end
end
