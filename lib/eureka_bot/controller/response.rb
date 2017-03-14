class EurekaBot::Controller::Response
  include ActiveSupport::Callbacks
  define_callbacks :add

  attr_reader :logger, :data
  attr_accessor :controller

  def initialize(logger: EurekaBot.logger)
    @logger = logger
    @data   = []
    @order_counter = 0
  end

  def add(params={})
    run_callbacks :add do
      @data << {
          order: @order_counter += 1
      }.merge(params)
    end
  end

  def <<(params={})
    add(params)
  end

  def to_a
    data
  end

end
