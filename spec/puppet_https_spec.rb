require 'spec_helper'
require_relative '../lib/puppet_https'

describe PuppetHttps do
  before :each do
    @classifier_url = 'https://puppetmaster.local:4433/classifier-api'

    auth_info = {
      "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
      "certificate_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem",
      "private_key_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem"
    }

    @puppet_https = PuppetHttps.new(auth_info)
  end

  describe "#new" do
    it "takes an auth hash and returns a PuppetHttps object" do
      expect(@puppet_https).to be_an_instance_of PuppetHttps
    end
  end

end
