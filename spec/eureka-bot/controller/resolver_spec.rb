require 'spec_helper'

RSpec.describe EurekaBot::Controller::Resolver do
  context '#execute' do
    let(:controller_class) do
      Class.new(EurekaBot::Controller) do
        def some_action
          answer(some_action: 'finished')
        end
      end
    end

    let(:resolver) do
      Class.new(EurekaBot::Controller::Resolver).new(message: {})
    end

    before do
      allow(resolver).to receive(:resolve).and_return(
          controller: controller_class,
          action:     :some_action
      )
      resolver.execute
    end

    it do
      expect(resolver.controller.response.to_a).to include(include(some_action: 'finished'))
    end
  end
end
