require 'spec_helper'
require_relative '../../lib/puppetclassify/classes.rb'
require_relative '../../lib/puppetclassify'

describe Classes do
  before :each do
    @classifier_url = 'https://puppetmaster.local:4433/classifier-api'

    auth_info = {
      "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
      "certificate_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem",
      "private_key_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem"
    }

    @puppetclassify = PuppetClassify.new(@classifier_url, auth_info)

    @sample_classes = "[{\"parameters\":{},\"environment\":\"production\",\"name\":\"pe_repo::platform::solaris_11_i386\"},{\"parameters\":{},\"environment\":\"production\",\"name\":\"pe_postgresql::server::passwd\"},{\"parameters\":{},\"environment\":\"production\",\"name\":\"puppet_enterprise::profile::certificate_authority\"},{\"parameters\":{},\"environment\":\"production\",\"name\":\"pe_repo::platform::el_4_i386\"},{\"parameters\":{},\"environment\":\"production\",\"name\":\"pe_repo::platform::ubuntu_1004_i386\"},{\"parameters\":{},\"environment\":\"production\",\"name\":\"pe_repo::platform::osx_109_x86_64\"}]"
  end

  describe "#get_classes" do
    it "gets an array of all of the classes" do
      stub_request(:get, "#{@classifier_url}/v1/classes").
                 with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
                 to_return(:status => 200, :body => @sample_classes, :headers => {})
      expect(@puppetclassify.classes.get_classes).to be_an_instance_of Array
    end
  end

  describe "#get_environment_classes" do
    let(:environment_name) { environment_name = 'production' }

    it "gets an array of all the classes in a specific environment" do
      stub_request(:get, "#{@classifier_url}/v1/environments/#{environment_name}/classes").
                 with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
                 to_return(:status => 200, :body => @sample_classes, :headers => {})
      expect(@puppetclassify.classes.get_environment_classes(environment_name)).to be_an_instance_of Array
    end
  end

  describe "#get_environment_class" do
    let(:environment_name) { environment_name = 'production' }
    let(:class_name) { class_name = 'puppet_enterprise::profile::certificate_authority' }
    let(:response_body) { response_body = "{\"parameters\":{},\"environment\":\"production\",\"name\":\"puppet_enterprise::profile::certificate_authority\"}" }

    it "gets a class from a specific environment" do
      stub_request(:get, "#{@classifier_url}/v1/environments/#{environment_name}/classes/#{class_name}").
                 with(:headers => {'Accept'=>'application/json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
                 to_return(:status => 200, :body => response_body, :headers => {})
      expect(@puppetclassify.classes.get_environment_class(environment_name, class_name)).to be_an_instance_of Hash
    end
  end
end
