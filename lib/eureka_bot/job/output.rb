class EurekaBot::Job::Output < EurekaBot::Job
  queue_as :output

  def perform(sender_class, message, *args)
    instrument 'job.output' do
      sender_class.constantize.new.deliver(message, *args)
    end
  rescue StandardError => e
    EurekaBot.exception_handler(e, self.class, sender_class: sender_class, message: message)
  end

end
