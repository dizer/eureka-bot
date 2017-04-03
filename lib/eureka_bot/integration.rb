module EurekaBot::Integration
  extend ActiveSupport::Autoload

  autoload :NewRelic

  if defined?(::NewRelic)
    EurekaBot.logger.debug 'loading NewRelic integration'
    EurekaBot.include(EurekaBot::Integration::NewRelic)
  end

end
