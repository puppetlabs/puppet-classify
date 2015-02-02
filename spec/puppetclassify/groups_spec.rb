require 'spec_helper'
require_relative '../../lib/puppetclassify'

describe Groups do
  before :each do
    @classifier_url = 'https://puppetmaster.local:4433/classifier-api'

    auth_info = {
      "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
      "certificate_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem",
      "private_key_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem"
    }

    @puppetclassify = PuppetClassify.new(@classifier_url, auth_info)

    @simple_response_body = "{\"environment_trumps\":false,\"parent\":\"96d58c24-3cc5-4b07-bd36-44e0932bb041\",\"name\":\"PE Master\",\"rule\":[\"or\",[\"=\",\"name\",\"puppetmaster.local\"]],\"variables\":{},\"id\":\"d8fd0add-4671-4cc7-92a5-d6e58bb7898d\",\"environment\":\"production\",\"classes\":{\"puppet_enterprise::profile::master::mcollective\":{},\"puppet_enterprise::profile::mcollective::peadmin\":{},\"puppet_enterprise::profile::master\":{},\"pe_repo\":{},\"pe_repo::platform::el_6_x86_64\":{}}}"

  end

  describe "#newobject" do
    it "takes a classifier url and auth info hash and returns a PuppetClassify object" do
      expect(@puppetclassify.groups).to be_an_instance_of Groups
    end
  end

  describe "#get_groups" do
    it "returns a string of groups" do
      stub_request(:get, "#{@classifier_url}/v1/groups").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => @simple_response_body, :headers => {})
      expect(@puppetclassify.groups.get_groups).to be_an_instance_of Hash
    end
  end

  describe "#get_group" do
    it "returns a group given an ID" do
      stub_request(:get, "#{@classifier_url}/v1/groups/96d58c24-3cc5-4b07-bd36-44e0932bb041").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => @simple_response_body, :headers => {})
      expect(@puppetclassify.groups.get_group('96d58c24-3cc5-4b07-bd36-44e0932bb041')).to be_an_instance_of Hash
    end

    it "returns nil if no group can be found given an invalid ID" do
      stub_request(:get, "#{@classifier_url}/v1/groups/fc500c43-5065-469b-91fc-37ed0e500e81").
        with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 404, :headers => {})
      expect(@puppetclassify.groups.get_group('fc500c43-5065-469b-91fc-37ed0e500e81')).to be_nil
    end
  end

  describe "#get_group_id" do
    it "returns a group id given a group name" do
    end
  end

  describe "#create_group" do
    let(:example_group) { example_group = {"name"=>"examplegroup", "description"=>"A cool group", "environment"=>"production", "parent"=>"00000000-0000-4000-8000-000000000000", "classes"=>{}} }

    let(:group_with_id) { group_with_id = {"name"=>"groupwithid", "description"=>"A cool group", "environment"=>"production", "parent"=>"00000000-0000-4000-8000-000000000000", "classes"=>{}, "id"=>"fc500c43-5065-469b-91fc-37ed0e500e81"} }

    it "creates a group with a specified id" do
      stub_request(:put, "#{@classifier_url}/v1/groups/#{group_with_id['id']}").
                 with(:body => group_with_id,
                      :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
                 to_return(:status => 303, :body => "", :headers => {})
        expect(@puppetclassify.groups.create_group(group_with_id)).to be_an_instance_of String
    end

    it "creates a group without a specified id" do
      stub_request(:post, "#{@classifier_url}/v1/groups").
                 with(:body => example_group,
                      :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
                 to_return(:status => 303, :body => "", :headers => {:location => "/classifier-api/v1/groups/777fa762-4cbc-4dff-af6b-38cc32acbca0"})
        expect(@puppetclassify.groups.create_group(example_group)).to be_an_instance_of String
    end
  end

  describe "#update_group" do
    let(:example_group_delta) { example_group_delta = {"description"=>"A super cool group", "id"=>"fc500c43-5065-469b-91fc-37ed0e500e81"} }

    it "updates a group given a delta" do
      stub_request(:post, "#{@classifier_url}/v1/groups/#{example_group_delta['id']}").
                 with(:body => example_group_delta,
                      :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
                 to_return(:status => 200, :body => "", :headers => {})
      expect(@puppetclassify.groups.update_group(example_group_delta)).to be_nil
    end
  end

  describe "#delete_group" do
    let(:id) { id = "fc500c43-5065-469b-91fc-37ed0e500e81" }

    it "deletes a group given an ID" do
      stub_request(:delete, "#{@classifier_url}/v1/groups/#{id}").
                 with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
                 to_return(:status => 204, :body => "", :headers => {})
      expect(@puppetclassify.groups.delete_group(id)).to be_nil
    end
  end

end
