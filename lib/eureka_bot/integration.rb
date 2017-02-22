module EurekaBot::Integration
  extend ActiveSupport::Autoload

  if defined?(NewRelic)
    EurekaBot.logger.debug 'loading NewRelic integration'
    autoload :NewRelic
    EurekaBot.include(EurekaBot::Integration::NewRelic)
  end

end
