class EurekaBot::Resolver
  include EurekaBot::Instrumentation

  class ActionNotFound < StandardError; end
  class ControllerNotFound < StandardError; end

  attr_reader :logger, :message, :response, :controller

  def initialize(message:, response: nil, logger: EurekaBot.logger)
    @logger   = logger
    @message  = message
    @response = response
  end

  def resolve
    nil
  end

  def resolved
    @resolved ||= begin
      resolved = resolve
      instrument 'resolver.resolved', level: Logger::INFO, result: resolved, message: message
      resolved
    end
  end

  def execute
    raise ControllerNotFound.new("Can't resolve #{message}") unless resolved
    @controller = resolve_controller(resolved[:controller]).new(
        params:   resolved[:params] || {},
        message:  message,
        logger:   logger,
        response: response
    )
    instrument 'resolver.execute' do
      controller.execute(resolved[:action])
    end
    self
  end

  def parameterize(str)
    ActiveSupport::Inflector.parameterize(str, separator: '_').presence
  end

  def decode_params(str, delimiter: ':')
    action_raw, version, *params = str.split(delimiter)
    {
        action:  parameterize(action_raw),
        version: version,
        params:  {raw: params, version: version} || {}
    }
  end

  def encode_params(action:, version: 'v1', params: [])
    ([action, version] + params.map(&:to_json)).join(':')
  end

  def resolve_controller(klass)
    instrument 'resolver.resolve_controller' do
      return klass if klass.is_a?(Class) && klass <= EurekaBot::Controller
      camelized = ActiveSupport::Inflector.camelize(klass)
      camelized = [camelized, 'Controller'].join unless camelized.include?('Controller')
      [
          camelized,
          [controller_namespace, camelized].join('::')
      ].each do |variant|
        constant= ActiveSupport::Inflector.safe_constantize(variant)
        return constant if constant
      end
      raise ControllerNotFound.new(klass)
    end
  end

  def controller_namespace
    EurekaBot
  end

end
