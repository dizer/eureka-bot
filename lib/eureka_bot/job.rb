require 'sucker_punch'

class EurekaBot::Job
  include ::SuckerPunch::Job
  include EurekaBot::Instrumentation

  def perform(resolver_class, message)
    instrument 'job.perform' do
      klass = if resolver_class <= EurekaBot::Resolver
                resolver_class
              elsif resolver_class <= String
                resolver_class.constantize
              else
                raise UnknownResolverClass.new(resolver_class)
              end

      resolver = klass.new(
          message:  message,
          logger:   logger
      )
      resolver.execute
    end
  end

  def logger
    EurekaBot.logger
  end

  class UnknownResolverClass < StandardError; end
end
