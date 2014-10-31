require 'puppet_https'
require 'classify/groups'
require 'classify/environments'
require 'classify/classes'
require 'classify/nodes'

class Classify
  def initialize(nc_api_url, https_settings)
    @nc_api_url = nc_api_url
    @puppet_https = PuppetHttps.new(https_settings)
  end

  def groups
    if @groups
      @groups
    else
      @groups = Groups.new(@nc_api_url, @puppet_https)
    end
  end

  def nodes
    if @nodes
      @nodes
    else
      @nodes = Nodes.new(@nc_api_url, @puppet_https)
    end
  end

  def environments
    if @environments
      @environments
    else
      @environments = Environments.new(@nc_api_url, @puppet_https)
    end
  end

  def classes
    if @classes
      @classes
    else
      @classes = Classes.new(@nc_api_url, @puppet_https)
    end
  end
end
