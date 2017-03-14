$:.unshift File.dirname(__FILE__)

require 'active_support'
require 'active_support/core_ext'
require 'active_support/concern'
require 'active_support/notifications'

module EurekaBot
  extend ActiveSupport::Autoload
  cattr_reader :logger

  autoload :Controller
  autoload :Exceptions
  autoload :Instrumentation
  autoload :Job
  autoload :Resolver
  autoload :Version

  eager_autoload do
    autoload :Integration
    autoload :Notifications
  end

  include EurekaBot::Exceptions

  def self.logger=(logger)
    @@logger = logger
    EurekaBot::Job.logger = logger
    logger
  end
end

EurekaBot.logger       = Logger.new(nil)
EurekaBot.logger.level = Logger::INFO

EurekaBot.eager_load!
