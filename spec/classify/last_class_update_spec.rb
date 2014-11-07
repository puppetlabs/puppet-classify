require 'spec_helper'
require_relative '../../lib/classify/last_class_update.rb'
require_relative '../../lib/classify'

describe LastClassUpdate do
  before :each do
    @classifier_url = 'https://puppetmaster.local:4433/classifier-api'

    auth_info = {
      "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
      "certificate_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem",
      "private_key_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem"
    }

    @classify = Classify.new(@classifier_url, auth_info)
  end

  describe "#get" do
    let(:response_body) { response_body = {"last_update"=>"2014-11-07T17:38:44.805Z"} }
    it "returns gives a response for last class update" do
      stub_request(:get, "#{@classifier_url}/v1/last-class-update").
                 with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
                 to_return(:status => 200, :body => response_body.to_json, :headers => {})
      expect(@classify.last_class_update.get).to be_an_instance_of Hash
    end
  end
end
