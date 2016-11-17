require 'sucker_punch'

SuckerPunch.exception_handler = -> (e, klass, args) {
  NewRelic::Agent.notice_error(e, custom_params: args)
}

EurekaBot::Controller.exception_handler = -> (e, args) {
  NewRelic::Agent.notice_error(e, custom_params: args)
}
