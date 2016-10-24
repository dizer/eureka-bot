class EurekaBot::Controller::Resolver

  attr_reader :logger, :message, :response

  def initialize(message:, response: nil, logger: Logger.new(STDOUT))
    @logger   = logger
    @message  = message
    @response = response
  end

  def resolve
    nil
  end

  def execute
    resolved = resolve
    raise ActionNotFound.new("Cant resolve path for #{message}") unless resolved
    controller = resolved[:controller].new(
        params:   {},
        message:  message,
        logger:   logger,
        response: response
    )
    controller.execute(resolved[:action])
  end

  class ActionNotFound < StandardError;
  end

end
