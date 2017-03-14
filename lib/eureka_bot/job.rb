require 'active_job'

class EurekaBot::Job < ActiveJob::Base
  extend ActiveSupport::Autoload
  autoload :Input
  autoload :Output
  include EurekaBot::Instrumentation

  queue_as do
    self.class.name.underscore.gsub('/', '__')
  end

  self.logger = EurekaBot.logger
end
