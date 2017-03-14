module EurekaBot::Notification
  def self.log_notification(severity=::Logger::DEBUG, name, started, finished, id, payload)
    EurekaBot.logger.add(
        severity,
        {
            name:           name,
            execution_time: finished - started,
            started:        started,
            finished:       finished,
            id:             id,
            payload:        payload
        }.to_json
    )
  end
end

ActiveSupport::Notifications.subscribe /eureka-bot\..*/ do |*args|
  severity = if args[0] == 'eureka-bot.job.perform'
               ::Logger::INFO
             else
               ::Logger::DEBUG
             end
  EurekaBot::Notification.log_notification(severity, *args)
end

