require 'spec_helper'

RSpec.describe EurekaBot::Instrumentation do
  context 'level' do
    let(:resolver) { EurekaBot::Resolver.new(message: {}) }
    it do
      payloads = []
      ActiveSupport::Notifications.subscribe /.*/ do |name, started, finished, id, payload|
        expect(payload).to include(:level)
        payloads << payload
      end

      expect{resolver.resolved}.to change{payloads.length}.from(0).to(1)
    end
  end
end
