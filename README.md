# puppet classify

A ruby library to interface with the classifier service

[![Gem Version](https://badge.fury.io/rb/puppetclassify.svg)](https://badge.fury.io/rb/puppetclassify)

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

### Basic case

If you are wanting to get all of the groups the classifier knows about:

```ruby
require 'puppetclassify'
# URL of classifier as well as certificates and private key for auth
auth_info = {
  "ca_certificate_path" => "/etc/puppetlabs/puppet/ssl/certs/ca.pem",
  "certificate_path"    => "/etc/puppetlabs/puppet/ssl/certs/myhostname.vm.pem",
  "private_key_path"    => "/etc/puppetlabs/puppet/ssl/private_keys/myhostname.vm.pem",
  "read_timeout"        => 90 # optional timeout, defaults to 90 if this key doesn't exist
}

classifier_url = 'https://puppetmaster.local:4433/classifier-api'
puppetclassify = PuppetClassify.new(classifier_url, auth_info)
# Get all the groups
puppetclassify.groups.get_groups
```

### Taking action on a specific group by name

If you have a group you want to modify, but do not know the group ID:

```ruby
require 'puppetclassify'
# URL of classifier as well as certificates and private key for auth
auth_info = {
  "ca_certificate_path" => "/etc/puppetlabs/puppet/ssl/certs/ca.pem",
  "certificate_path"    => "/etc/puppetlabs/puppet/ssl/certs/myhostname.vm.pem",
  "private_key_path"    => "/etc/puppetlabs/puppet/ssl/private_keys/myhostname.vm.pem"
}

classifier_url = 'https://puppetmaster.local:4433/classifier-api'
puppetclassify = PuppetClassify.new(classifier_url, auth_info)

my_group_id = puppetclassify.groups.get_group_id("My Group Name")
group_delta = {"variables"=>{"key"=>"value"}, "id"=>my_group_id, "classes"=>{"motd"=>{"content"=>"hello!"}}} # an example to update a groups variables and classes
puppetclassify.groups.update_group(group_delta)
```

## Library Docs

[rubydoc](http://www.rubydoc.info/gems/puppetclassify/0.1.0)
