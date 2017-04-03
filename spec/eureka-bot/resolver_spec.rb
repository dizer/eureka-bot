require 'spec_helper'

RSpec.describe EurekaBot::Resolver do
  context '#execute' do
    let(:controller_class) do
      Class.new(EurekaBot::Controller) do
        def some_action
          answer(some_action: 'finished')
        end
      end
    end

    let(:resolver) do
      Class.new(EurekaBot::Resolver).new(message: {})
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

  context '#exception' do
    let(:controller_class) do
      Class.new(EurekaBot::Controller) do
        def some_action
          raise StandardError.new
        end
      end
    end

    let(:resolver) do
      Class.new(EurekaBot::Resolver).new(message: {})
    end

    before do
      allow(resolver).to receive(:resolve).and_return(
          controller: controller_class,
          action:     :some_action
      )
    end

    it do
      expect{resolver.execute}.to raise_error(StandardError)
    end
  end

  context 'namespace' do
    let(:controller_class) do
      Class.new(EurekaBot::Controller) do
        def some_action
          answer(some_action: 'finished')
        end
      end
    end

    let(:resolver_class) do
      Class.new(EurekaBot::Resolver) do
        def resolve
            return {
                controller: 'test',
                action:     :some_action
            }
        end

        def controller_namespace
          NamespaceTestResolver
        end
      end
    end

    let(:resolver) do
      resolver_class.new(message: {})
    end

    before do
      module NamespaceTestResolver; end
      NamespaceTestResolver::TestController = controller_class
    end

    it do
      expect(resolver.resolve).to eq(controller: 'test', action: :some_action)
      resolver.execute
      expect(resolver.controller.response.to_a).to include(include(some_action: 'finished'))
    end
  end
end
