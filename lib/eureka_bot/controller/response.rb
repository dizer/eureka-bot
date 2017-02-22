class EurekaBot::Controller::Response
  include ActiveSupport::Callbacks
  define_callbacks :add

  attr_reader :logger, :data
  attr_accessor :controller

  def initialize(logger: EurekaBot.logger)
    @logger = logger
    @data   = []
  end

  def add(params={})
    run_callbacks :add do
      @data << params
    end
  end

  def <<(params={})
    add(params)
  end

  def to_a
    data
  end

end
