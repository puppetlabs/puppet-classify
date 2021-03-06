require 'puppet_https'
require 'puppetclassify/groups'
require 'puppetclassify/environments'
require 'puppetclassify/classes'
require 'puppetclassify/nodes'
require 'puppetclassify/import_hierarchy'
require 'puppetclassify/update_classes'
require 'puppetclassify/validate'
require 'puppetclassify/rules'
require 'puppetclassify/last_class_update'
require 'puppetclassify/classification'
require 'puppetclassify/commands'

class PuppetClassify
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

  def import_hierarchy
    if @import_hierarchy
      @import_hierarchy
    else
      @import_hierarchy = ImportHierarchy.new(@nc_api_url, @puppet_https)
    end
  end

  def update_classes
    if @update_classes
      @update_classes
    else
      @update_classes = UpdateClasses.new(@nc_api_url, @puppet_https)
    end
  end

  def validate
    if @validate
      @validate
    else
      @validate = Validate.new(@nc_api_url, @puppet_https)
    end
  end

  def rules
    if @rules
      @rules
    else
      @rules = Rules.new(@nc_api_url, @puppet_https)
    end
  end

  def last_class_update
    if @last_class_update
      @last_class_update
    else
      @last_class_update = LastClassUpdate.new(@nc_api_url, @puppet_https)
    end
  end

  def classification
    if @classification
      @classification
    else
      @classification = Classification.new(@nc_api_url, @puppet_https)
    end
  end

  def commands
    if @commands
      @commands
    else
      @commands = Commands.new(@nc_api_url, @puppet_https)
    end
  end
end
