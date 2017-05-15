require 'spec_helper'
require_relative '../lib/puppet_https'

describe PuppetHttps do
  describe "with specified certificate auth" do
    before :each do
      @classifier_url = 'https://puppetmaster.local:4433/classifier-api'

      private_key_path    = "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem"
      certificate_path    = "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem"
      ca_certificate_path = "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem"

      auth_info = {
        "private_key_path"    => private_key_path,
        "certificate_path"    => certificate_path,
        "ca_certificate_path" => ca_certificate_path,
      }

      expect(File).to receive("exists?").with(certificate_path).and_return(true)
      expect(File).to receive("exists?").with(private_key_path).and_return(true)
      expect(File).to receive("exists?").with(ca_certificate_path).and_return(true)

      expect(File).to receive("read").with(certificate_path).and_return('a cert')
      expect(File).to receive("read").with(private_key_path).and_return('a key')
      expect(OpenSSL::X509::Certificate).to receive("new").with('a cert').and_return('a cert object')
      expect(OpenSSL::PKey::RSA).to receive("new").with('a key').and_return('a key object')
      @puppet_https = PuppetHttps.new(auth_info)
    end

    describe "#new" do
      it "takes an auth hash and returns a PuppetHttps object" do
        expect(@puppet_https).to be_an_instance_of PuppetHttps
        expect(@puppet_https).to have_attributes(
          :auth_method => 'cert',
        )
      end
    end
  end

  describe "with token auth" do
    describe "with passed token" do
      before :each do
        @classifier_url = 'https://puppetmaster.local:4433/classifier-api'

        auth_info = {
          "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
          "token"               => "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
        }

        @puppet_https = PuppetHttps.new(auth_info)
      end

      describe "#new" do
        it "takes an auth hash and returns a PuppetHttps object" do
          expect(@puppet_https).to be_an_instance_of PuppetHttps
          expect(@puppet_https).to have_attributes(
            :auth_method => 'token',
            :token       => "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
          )
        end
      end
    end

    describe "with token path" do
      before :each do
        @classifier_url = 'https://puppetmaster.local:4433/classifier-api'

        auth_info = {
          "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
          "token_path"          => "/home/foo/.puppetlabs/token",
        }

        @puppet_https = PuppetHttps.new(auth_info)
      end

      describe "#new" do
        it "takes an auth hash and returns a PuppetHttps object" do
          expect(@puppet_https).to be_an_instance_of PuppetHttps
          expect(@puppet_https).to have_attributes(
            :auth_method => 'token',
            :token_path  => "/home/foo/.puppetlabs/token",
          )
        end
      end
    end
  end

  describe "with no auth method specified" do
    default_token_path = File.join(ENV['HOME'], '.puppetlabs', 'token')

    describe "and a token file at the default location" do
      it "uses the token file from the default location" do
        expect(File).to receive("exists?").with(default_token_path).and_return(true)
        @puppet_https = PuppetHttps.new({})
        expect(@puppet_https).to be_an_instance_of PuppetHttps
        expect(@puppet_https).to have_attributes(
          :auth_method => 'token',
          :token_path  => default_token_path,
        )
      end
    end

    describe "and no token file at the default location" do
      it "raises an exception" do
        expect(File).to receive("exists?").with(default_token_path).and_return(false)
        expect { @puppet_https = PuppetHttps.new({}) }.to raise_error(RuntimeError, /No authentication methods available/)
      end
    end
  end


end
