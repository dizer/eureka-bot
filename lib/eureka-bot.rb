$:.unshift File.dirname(__FILE__)

require 'active_support'
require 'active_support/core_ext'

module EurekaBot
  extend ActiveSupport::Autoload

  autoload :Controller
  autoload :Job
  autoload :Version

end
