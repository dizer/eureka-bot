require 'spec_helper'

RSpec.describe EurekaBot::Job do
  context '#execute' do
    let(:resolver_class) do
      class TestResolver < EurekaBot::Resolver
      end
      TestResolver
    end

    let(:controller_class) do
      class TestController < EurekaBot::Controller
        def some_action
          answer(some_action: 'finished')
        end
      end
      TestController
    end

    let(:job_class) do
      $job_result = nil
      class TestJob < EurekaBot::Job::Input
        def perform(resolver_class, message)
          $job_result = super
        end
      end
      TestJob
    end

    after do
      Object.send(:remove_const, :TestController)
      Object.send(:remove_const, :TestJob)
      Object.send(:remove_const, :TestResolver)
    end

    before do
      allow_any_instance_of(resolver_class).to receive(:resolve).and_return(
          controller: controller_class,
          action:     :some_action
      )

      job_class.perform_later(resolver_class.to_s, {})
    end

    it do
      expect($job_result).to be
      expect(
          $job_result.controller.response.to_a
      ).to include(include(some_action: 'finished'))
    end
  end
end
