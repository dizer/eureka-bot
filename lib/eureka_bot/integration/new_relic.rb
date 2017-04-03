module EurekaBot::Integration::NewRelic
  extend ActiveSupport::Concern

  included do
    add_exception_handler do |e, klass, args|
      ::NewRelic::Agent.notice_error(e, custom_params: args)
    end
  end
end

