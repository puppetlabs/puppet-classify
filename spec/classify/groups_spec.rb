require 'spec_helper'
require 'webmock'
require_relative '../../lib/classify/groups.rb'
require_relative '../../lib/classify'

describe Groups do
  before :each do
    classifier_url = 'https://puppetmaster.local:4433/classifier-api'

    auth_info = {
      "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
      "certificate_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem",
      "private_key_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem"
    }

    @classify = Classify.new(classifier_url, auth_info)
  end

  describe "#newobject" do
    it "takes a classifier url and auth info hash and returns a Classify object" do
      expect(@classify.groups).to be_an_instance_of Groups
    end
  end

end
