require 'spec_helper'
require_relative '../lib/classify'

describe Classify do
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
      expect(@classify).to be_an_instance_of Classify
    end

    it "has methods with objects that are not nil" do
      expect(@classify.groups).to be_truthy
      expect(@classify.nodes).to be_truthy
      expect(@classify.environments).to be_truthy
      expect(@classify.classes).to be_truthy
      expect(@classify.import_hierarchy).to be_truthy
      expect(@classify.update_classes).to be_truthy
      expect(@classify.validate).to be_truthy
      expect(@classify.rules).to be_truthy
      expect(@classify.last_class_update).to be_truthy
      expect(@classify.classification).to be_truthy
    end
  end

end
