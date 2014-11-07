require 'spec_helper'
require_relative '../../lib/classify'

describe Nodes do
  before :each do
    @classifier_url = 'https://puppetmaster.local:4433/classifier-api'

    auth_info = {
      "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
      "certificate_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem",
      "private_key_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem"
    }

    @classify = Classify.new(@classifier_url, auth_info)
  end

  describe "#get_nodes" do
  end

  describe "#get_node" do
  end
end
