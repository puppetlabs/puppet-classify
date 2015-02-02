require 'spec_helper'
require_relative '../lib/puppetclassify'

describe PuppetClassify do
  before :each do
    classifier_url = 'https://puppetmaster.local:4433/classifier-api'

    auth_info = {
      "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
      "certificate_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem",
      "private_key_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem"
    }

    @puppetclassify = PuppetClassify.new(classifier_url, auth_info)
  end

  describe "#newobject" do
    it "takes a classifier url and auth info hash and returns a PuppetClassify object" do
      expect(@puppetclassify).to be_an_instance_of PuppetClassify
    end

    it "has methods with objects that are not nil" do
      expect(@puppetclassify.groups).to be_truthy
      expect(@puppetclassify.nodes).to be_truthy
      expect(@puppetclassify.environments).to be_truthy
      expect(@puppetclassify.classes).to be_truthy
      expect(@puppetclassify.import_hierarchy).to be_truthy
      expect(@puppetclassify.update_classes).to be_truthy
      expect(@puppetclassify.validate).to be_truthy
      expect(@puppetclassify.rules).to be_truthy
      expect(@puppetclassify.last_class_update).to be_truthy
      expect(@puppetclassify.classification).to be_truthy
    end
  end

end
