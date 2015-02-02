require 'spec_helper'
require_relative '../../lib/puppetclassify'

describe UpdateClasses do
  before :each do
    @classifier_url = 'https://puppetmaster.local:4433/classifier-api'

    auth_info = {
      "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
      "certificate_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem",
      "private_key_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem"
    }

    @puppetclassify = PuppetClassify.new(@classifier_url, auth_info)
  end

  describe "#update" do
    it "sends an update message to the classifier" do
      stub_request(:post, "#{@classifier_url}/v1/update-classes").
                 with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
                 to_return(:status => 201, :body => "", :headers => {})
      expect(@puppetclassify.update_classes.update).to be_nil
    end
  end
end
