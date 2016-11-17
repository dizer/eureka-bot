class EurekaBot::Controller
  extend ActiveSupport::Autoload
  include ActiveSupport::Callbacks
  define_callbacks :action

  autoload :Response
  autoload :Resolver

  attr_reader :params, :message, :logger, :response
  cattr_accessor :exception_handler

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

  def trace_error(e, params={})
    logger.error(e)
    logger.error(e.http_body) if e.respond_to?(:http_body)
    self.class.exception_handler.call(e, params) if self.class.exception_handler
  end

  def self.has_action?(action)
    return false unless action.present?
    public_instance_methods(false).include?(action.to_sym)
  end

  class UnknownAction < StandardError; end

end
