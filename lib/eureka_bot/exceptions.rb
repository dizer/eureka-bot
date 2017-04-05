module EurekaBot::Exceptions
  extend ActiveSupport::Concern

  included do
    cattr_accessor :exception_chain

    def self.add_exception_handler(&block)
      self.exception_chain = (self.exception_chain || []) + [block]
    end

    def self.exception_handler(e, klass, args)
      self.exception_chain.each do |handler|
        handler.call(e, klass, args) rescue nil
      end
    end

    add_exception_handler do |e, klass, args|
      EurekaBot.logger.error(
          {
              class:     e.class.to_s,
              message:   e.message,
              args:      args,
              backtrace: e.backtrace
          }.to_json
      )
    end
  end
end
