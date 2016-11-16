class EurekaBot::Controller
  extend ActiveSupport::Autoload
  include ActiveSupport::Callbacks
  define_callbacks :action

  autoload :Response
  autoload :Resolver

  attr_reader :params, :message, :logger, :response

  def initialize(params: {}, message: nil, response: nil, logger: Logger.new(STDOUT))
    @params   = params
    @message  = message
    @logger   = logger
    @response = response || response_class.new(logger: logger)
    @response.controller = self
  end

  def execute(action)
    if respond_to?(action, include_all: false)
      run_callbacks :action do
        public_send(action)
      end
    else
      raise UnknownAction.new("Action #{action} is not defined in #{self.class}")
    end
    self
  end

  def answer(params={})
    response << params
  end

  def response_class
    EurekaBot::Controller::Response
  end

  class UnknownAction < StandardError; end

end
