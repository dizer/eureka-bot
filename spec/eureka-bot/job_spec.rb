require 'spec_helper'

RSpec.describe EurekaBot::Job do
  context '#execute' do
    let(:controller_class) do
      Class.new(EurekaBot::Controller) do
        def some_action
          answer(some_action: 'finished')
        end
      end
    end

    let(:resolver_class) do
      Class.new(EurekaBot::Resolver)
    end

    let(:job_class) do
      $job_result = nil
      Class.new(EurekaBot::Job) do
        def perform(resolver_class, message)
          $job_result = super
        end
      end
    end

    before do
      allow_any_instance_of(resolver_class).to receive(:resolve).and_return(
          controller: controller_class,
          action:     :some_action
      )
      job_class.perform_async(resolver_class, {})
    end

    it do
      expect($job_result.controller.response.to_a).to include(include(some_action: 'finished'))
    end
  end
end
