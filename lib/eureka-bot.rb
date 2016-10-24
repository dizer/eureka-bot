$:.unshift File.dirname(__FILE__)

require 'active_support'
require 'active_support/core_ext'

module EurekaBot
  extend ActiveSupport::Autoload

  autoload :Version
  autoload :Controller
end
