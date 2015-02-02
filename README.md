# puppet classify

A ruby library to interface with the classifier service

## How to install

```
gem install puppetclassify
```

### Locally

```
gem build puppetclassify.gemspec
gem install puppetclassify-0.1.0.gem
```

## How to use

```ruby
require 'puppetclassify'
# URL of classifier as well as certificates and private key for auth
auth_info = {
  "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
  "certificate_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem",
  "private_key_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem"
}

classifier_url = 'https://puppetmaster.local:4433/classifier-api'
puppetclassify = PuppetClassify.new(classifier_url, auth_info)
# Get all the groups
puppetclassify.groups.get_groups
```
