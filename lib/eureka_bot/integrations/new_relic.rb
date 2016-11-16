require 'sucker_punch'

SuckerPunch.exception_handler = -> (e, klass, args) {
  NewRelic::Agent.notice_error(e, custom_params: args)
}
