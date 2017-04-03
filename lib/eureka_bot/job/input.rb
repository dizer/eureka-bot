class EurekaBot::Job::Input < EurekaBot::Job
  queue_as :input

  def perform(resolver_class, message)
    instrument 'job.input' do
      resolver = resolver_class.constantize.new(
          message: message,
          logger:  logger
      )
      resolver.execute
    end
  rescue StandardError => e
    EurekaBot.exception_handler(e, self.class, resolver_class: resolver_class, message: message)
  end

  class UnknownResolverClass < StandardError;
  end
end
