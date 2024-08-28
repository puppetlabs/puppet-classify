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

      expect(File).to receive("exist?").with(certificate_path).and_return(true)
      expect(File).to receive("exist?").with(private_key_path).and_return(true)
      expect(File).to receive("exist?").with(ca_certificate_path).and_return(true)

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

    describe "with passed empty token" do
      it "detects the empty token" do
        @classifier_url = 'https://puppetmaster.local:4433/classifier-api'

        auth_info = {
          "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
          "token"               => "",
        }

        expect { @puppet_https = PuppetHttps.new(auth_info) }.to raise_error(RuntimeError, /Received an empty string for token/)
      end
    end

    describe "with valid token path" do
      it "takes an auth hash and returns a PuppetHttps object" do
        @classifier_url = 'https://puppetmaster.local:4433/classifier-api'

        auth_info = {
          "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
          "token_path"          => "/home/foo/.puppetlabs/token",
        }

        expect(File).to receive(:exist?).with("/home/foo/.puppetlabs/token").and_return(true)
        expect(File).to receive(:zero?).with("/home/foo/.puppetlabs/token").and_return(false)
        expect(File).to receive(:exist?).with(auth_info['ca_certificate_path']).and_return(true)

        @puppet_https = PuppetHttps.new(auth_info)
        expect(@puppet_https).to be_an_instance_of PuppetHttps
        expect(@puppet_https).to have_attributes(
          :auth_method => 'token',
          :token_path  => "/home/foo/.puppetlabs/token",
        )
      end
    end

    describe "with token path specified for a non existant file" do
      it "detects the missing token file" do
        @classifier_url = 'https://puppetmaster.local:4433/classifier-api'

        auth_info = {
          "token_path"          => "/no/such/path",
        }
        expect(File).to receive(:exist?).with("/no/such/path").and_return(false)
        expect { @puppet_https = PuppetHttps.new(auth_info) }.to raise_error(RuntimeError, 'Token file not found at [/no/such/path]')
      end
    end
  end

  describe "with no auth method specified" do
    default_token_path = File.join('/homie/foo', '.puppetlabs', 'token')

    describe "and a token file at the default location" do
      it "uses the token file from the default location" do
        allow(ENV).to receive(:[]).with("HOME").and_return("/homie/foo")
        expect(File).to receive("exist?").with(default_token_path).twice.and_return(true)
        @puppet_https = PuppetHttps.new({})
        expect(@puppet_https).to be_an_instance_of PuppetHttps
        expect(@puppet_https).to have_attributes(
          :auth_method => 'token',
          :token_path  => default_token_path,
        )
      end
    end

    describe "and an empty token file at the default location" do

      it "raises an exception" do
        allow(ENV).to receive(:[]).with("HOME").and_return("/homie/foo")
        expect(File).to receive("exist?").twice.with(default_token_path).and_return(true)
        expect(File).to receive("zero?").with(default_token_path).and_return(true)

        expect { @puppet_https = PuppetHttps.new({}) }.to raise_error(RuntimeError, "Token file at [#{default_token_path}] is empty")
      end
    end

    describe "and no token file at the default location" do
      it "raises an exception" do
        allow(ENV).to receive(:[]).with("HOME").and_return("/homie/foo")
        expect(File).to receive("exist?").with(default_token_path).and_return(false)
        expect { @puppet_https = PuppetHttps.new({}) }.to raise_error(RuntimeError, /No authentication methods available/)
      end
    end
  end


end
