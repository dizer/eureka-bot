require 'spec_helper'

RSpec.describe EurekaBot::Controller do

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
end
