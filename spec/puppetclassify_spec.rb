require 'spec_helper'
require_relative '../lib/puppetclassify'

describe PuppetClassify do
  before :each do
    classifier_url = 'https://puppetmaster.local:4433/classifier-api'

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
