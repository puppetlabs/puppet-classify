require 'spec_helper'
require_relative '../../lib/classify/groups.rb'
require_relative '../../lib/classify'

describe Groups do
  before :each do
    @classifier_url = 'https://puppetmaster.local:4433/classifier-api'

    auth_info = {
      "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
      "certificate_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem",
      "private_key_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem"
    }

    @classify = Classify.new(@classifier_url, auth_info)

    @simple_response_body = "{\"environment_trumps\":false,\"parent\":\"96d58c24-3cc5-4b07-bd36-44e0932bb041\",\"name\":\"PE Master\",\"rule\":[\"or\",[\"=\",\"name\",\"puppetmaster.local\"]],\"variables\":{},\"id\":\"d8fd0add-4671-4cc7-92a5-d6e58bb7898d\",\"environment\":\"production\",\"classes\":{\"puppet_enterprise::profile::master::mcollective\":{},\"puppet_enterprise::profile::mcollective::peadmin\":{},\"puppet_enterprise::profile::master\":{},\"pe_repo\":{},\"pe_repo::platform::el_6_x86_64\":{}}}"

  end

  describe "#newobject" do
    it "takes a classifier url and auth info hash and returns a Classify object" do
      expect(@classify.groups).to be_an_instance_of Groups
    end
  end

  describe "#get_groups" do
    it "returns a string of groups" do
      stub_request(:get, "#{@classifier_url}/v1/groups").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => @simple_response_body, :headers => {})
      expect(@classify.groups.get_groups).to be_an_instance_of Hash
    end
  end

  describe "#get_group" do
    it "returns a group given an ID" do
      stub_request(:get, "#{@classifier_url}/v1/groups/96d58c24-3cc5-4b07-bd36-44e0932bb041").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => @simple_response_body, :headers => {})
      expect(@classify.groups.get_group('96d58c24-3cc5-4b07-bd36-44e0932bb041')).to be_an_instance_of Hash
    end

    it "returns nil if no group can be found given an invalid ID" do
      stub_request(:get, "#{@classifier_url}/v1/groups/fc500c43-5065-469b-91fc-37ed0e500e81").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 404, :headers => {})
      expect(@classify.groups.get_group('fc500c43-5065-469b-91fc-37ed0e500e81')).to be_nil
    end
  end

end
