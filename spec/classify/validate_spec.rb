require 'spec_helper'
require_relative '../../lib/classify'

describe Validate do
  before :each do
    @classifier_url = 'https://puppetmaster.local:4433/classifier-api'

    auth_info = {
      "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
      "certificate_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem",
      "private_key_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem"
    }

    @classify = Classify.new(@classifier_url, auth_info)
  end

  describe "#validate" do
    let(:group) { group = {"name"=>"testgroup", "description"=>"A cool group", "environment"=>"production", "parent"=>"00000000-0000-4000-8000-000000000000", "classes"=>{}} }

    it "sends a group to be validated" do
      stub_request(:post, "#{@classifier_url}/v1/validate/group").
                 with(:body => group,
                      :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
                 to_return(:status => 200, :body => "", :headers => {})
      expect(@classify.validate.validate_group(group)).to be_nil
    end
  end
end
