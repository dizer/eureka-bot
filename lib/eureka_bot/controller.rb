class EurekaBot::Controller
  extend ActiveSupport::Autoload
  include ActiveSupport::Callbacks
  include EurekaBot::Instrumentation

  define_callbacks :action

  autoload :Response

  attr_reader :params, :message, :logger, :response
  # cattr_accessor :exception_handler

  def initialize(params: {}, message: nil, response: nil, logger: EurekaBot.logger)
    @params   = params
    @message  = message
    @logger   = logger
    @response = response || response_class.new(logger: logger)
    @response.controller = self
  end

  def execute(action)
    if respond_to?(action, include_all: false)
      instrument 'controller.execute' do
        run_callbacks :action do
          public_send(action)
        end
      end
    else
      raise UnknownAction.new("Action #{action} is not defined in #{self.class}")
    end
    self
  end

  def answer(params={})
    instrument 'controller.answer', params do
      response << params
    end
  end

  def redirect(controller, action)
    instance = controller.new(
        params:   params,
        message:  message,
        response: response,
        logger:   logger
    )
    instrument 'controller.redirect', {from: self.class.to_s, to: {controller: controller.to_s, action: action}} do
      instance.public_send(action)
    end
  end

  def response_class
    EurekaBot::Controller::Response
  end

  def trace_error(e, params={})
    logger.error(e.http_body) if e.respond_to?(:http_body)
    EurekaBot.exception_handler(e, self.class, params)
  end

  def self.has_action?(action)
    return false unless action.present?
    public_instance_methods(false).include?(action.to_sym)
  end

  class UnknownAction < StandardError; end

end
