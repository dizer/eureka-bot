module EurekaBot::Instrumentation
  extend ActiveSupport::Concern

  def instrument(name, payload=nil, &block)
    self.class.instrument(name, payload, &block)
  end

  def self.prefix
    'eureka-bot'
  end

  class_methods do
    def instrument(name, payload=nil, &block)
      ActiveSupport::Notifications.instrument [EurekaBot::Instrumentation.prefix, name].compact.join('.'), payload, &block
    end
  end

end
