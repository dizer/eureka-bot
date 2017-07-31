class EurekaBot::Controller::Response
  include ActiveSupport::Callbacks
  define_callbacks :add

  attr_reader :logger, :data
  attr_accessor :controller

  def initialize(logger: EurekaBot.logger)
    @logger = logger
    @data   = []
    @order_counters = {}
  end

  def add(**params)
    run_callbacks :add do
      if params[:order_queue]
        @order_counters[params[:order_queue]] = (@order_counters[params[:order_queue]] || 0) + 1
        @data << {
            order: @order_counters[params[:order_queue]]
        }.merge(params)
      else
        @data << params
      end
    end
  end

  def <<(params={})
    add(params)
  end

  def to_a
    data
  end

end
