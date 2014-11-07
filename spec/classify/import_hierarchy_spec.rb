require 'spec_helper'
require_relative '../../lib/classify'

describe ImportHierarchy do
  before :each do
    @classifier_url = 'https://puppetmaster.local:4433/classifier-api'

    auth_info = {
      "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
      "certificate_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem",
      "private_key_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem"
    }

    @classify = Classify.new(@classifier_url, auth_info)

    @import_group_hash = [{"environment_trumps"=>false, "parent"=>"00000000-0000-4000-8000-000000000000", "name"=>"default", "rule"=>["and", ["~", "name", ".*"]], "variables"=>{}, "id"=>"00000000-0000-4000-8000-000000000000", "environment"=>"production", "classes"=>{}},{"name"=>"testgroup", "description"=>"A cool group", "environment"=>"production", "parent"=>"00000000-0000-4000-8000-000000000000", "classes"=>{}}]

  end

  describe "#import" do
    it "sends a group hash to be imported" do
      stub_request(:post, "#{@classifier_url}/v1/import-hierarchy").
         with(:body => @import_group_hash.to_json,
              :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
         to_return(:status => 204, :body => "", :headers => {})
      expect(@classify.import_hierarchy.import(@import_group_hash)).to be_nil
    end
  end
end
