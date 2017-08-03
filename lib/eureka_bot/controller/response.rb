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

  def add(sync: false, **params)
    run_callbacks :add do
      message = params
      if message[:order_queue]
        @order_counters[message[:order_queue]] = (@order_counters[message[:order_queue]] || 0) + 1
        message = {order: @order_counters[message[:order_queue]]}.merge(message)
      end
      if sync
        self.class.sender_class.new.deliver(message)
      else
        @data << message
        nil
      end
    end
  end

  def <<(params={})
    add(params)
  end

  def to_a
    data
  end

  def self.sender_class
    @@sender_class ||= EurekaBot::Sender
  end

end
