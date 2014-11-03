# puppet classify

A ruby library to interface with the classifier service

## How to install

```
gem build classify.gemspec
gem install classify-0.1.0.gem
```

## How to use

```ruby
require 'classify'
# URL of classifier as well as certificates and private key for auth
auth_info = {
  "ca_certificate_path" => "/opt/puppet/share/puppet-dashboard/certs/ca_cert.pem",
  "certificate_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem",
  "private_key_path"    => "/opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem"
}

classifier_url = 'https://puppetmaster.local:4433/classifier-api'
classify = Classify.new(classifier_url, auth_info)
# Get all the groups
classify.groups.get_groups
```
