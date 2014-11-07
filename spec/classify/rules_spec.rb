require 'spec_helper'
require_relative '../../lib/classify'

describe Rules do
  before :each do
    @classifier_url = 'https://puppetmaster.local:4433/classifier-api'

    auth_info = {
      "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
      "certificate_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem",
      "private_key_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem"
    }

    @classify = Classify.new(@classifier_url, auth_info)
  end

  describe "#translate" do
    let(:rule) { rule = ["or",["=","name","puppetmaster.local"]] }
    let(:response_body) { response_body = "[\"or\",[\"=\",\"name\",\"puppetmaster.local\"]]" }

    it "gets an array of a translated rule" do
      stub_request(:post, "#{@classifier_url}/v1/rules/translate").
                 with(:body => rule.to_json,
                      :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
                 to_return(:status => 200, :body => response_body, :headers => {})
      expect(@classify.rules.translate(rule)).to be_an_instance_of Array
    end
  end
end
