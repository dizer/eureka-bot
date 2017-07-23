module EurekaBot::Instrumentation
  extend ActiveSupport::Concern

  def instrument(name, level: Logger::DEBUG, **payload, &block)
    self.class.instrument(name, level: level, **payload, &block)
  end

  def self.prefix
    'eureka-bot'
  end

  class_methods do
    def instrument(name, level: Logger::DEBUG, **payload, &block)
      ActiveSupport::Notifications.instrument(
          [
              EurekaBot::Instrumentation.prefix,
              name
          ].compact.join('.'),
          {level: level}.merge(payload),
          &block
      )
    end
  end

end
