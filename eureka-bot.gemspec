# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eureka_bot/version'

Gem::Specification.new do |spec|
  spec.name     = "eureka-bot"
  spec.version  = EurekaBot::VERSION
  spec.authors  = ["dizer"]
  spec.email    = ["dizeru@gmail.com"]
  spec.summary  = %q{Run your messenger bots}
  spec.homepage = ""
  spec.license  = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'activesupport', '>= 5.0.0'
  spec.add_runtime_dependency 'sucker_punch', '~> 2.0'

  spec.add_development_dependency 'rspec', '~> 3.5.0'
  spec.add_development_dependency 'webmock'
end
