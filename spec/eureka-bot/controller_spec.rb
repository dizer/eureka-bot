require 'spec_helper'

RSpec.describe EurekaBot::Controller do

  context 'execute' do
    let(:controller_klass) {
      Class.new(EurekaBot::Controller) do
        def sample_action; end
      end
    }
    let(:controller) { controller_klass.new }
    it do
      expect(controller).to receive(:sample_action).once
      controller.execute(:sample_action)
    end
  end

  context 'response' do
    let(:controller) { EurekaBot::Controller.new }

    it 'is EurekaBot::Controller::Response subclass' do
      expect(controller.response).to be_a_kind_of(EurekaBot::Controller::Response)
    end

    context '#answer' do
      let(:controller) do
        Class.new(EurekaBot::Controller) do
          def some_action
            answer(some_action: 'finished')
          end
        end.new
      end

      before do
        controller.some_action
      end

      it do
        expect(controller.response.to_a).to include(include(some_action: 'finished'))
      end
    end
  end

  context 'redirect' do
    let(:controller_klass) {
      Class.new(EurekaBot::Controller) do
        def sample_action_1
          redirect params[:klass], :sample_action_2
        end
        def sample_action_2; end
      end
    }
    let(:controller) { controller_klass.new(params: {klass: controller_klass}) }
    it do
      expect_any_instance_of(controller_klass).to receive(:sample_action_2).once
      controller.execute(:sample_action_1)
    end
  end
end
