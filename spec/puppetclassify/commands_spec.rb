require 'spec_helper'
require_relative '../../lib/puppetclassify'

describe Commands do
  before :each do
    @classifier_url = 'https://puppetmaster.local:4433/classifier-api'

    auth_info = {
      "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
      "certificate_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem",
      "private_key_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem"
    }

    @puppetclassify = PuppetClassify.new(@classifier_url, auth_info)
  end

  describe "#unpin_from_all" do
    let(:nodes) { nodes = ["foo", "bar"] }
    let(:resp_body) { resp_body = "{\"nodes\": [{\"name\": \"foo\", \"groups\": [{\"id\": \"8310b045-c244-4008-88d0-b49573c84d2d\", \"name\": \"Webservers\", \"environment\": \"production\"}, {\"id\": \"84b19b51-6db5-4897-9409-a4a3a94b7f09\", \"name\": \"Test\", \"environment\": \"test\"}]}, {\"name\": \"bar\", \"groups\": [{\"id\": \"84b19b51-6db5-4897-9409-a4a3a94b7f09\", \"name\": \"Test\", \"environment\": \"test\"}]}]}" }

    it "unpins all given nodes from all groups" do
       stub_request(:post, "#{@classifier_url}/v1/commands/unpin-from-all").
        with(:body => "{\"nodes\":[\"foo\",\"bar\"]}",
             :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => resp_body, :headers => {})
      expect(@puppetclassify.commands.unpin_from_all(nodes)).to be_an_instance_of Hash
    end
  end
end
