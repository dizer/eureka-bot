require 'spec_helper'

RSpec.describe EurekaBot::Controller::Response do

  context 'message order' do
    let(:response) { EurekaBot::Controller::Response.new }
    it do
      response.add(order_queue: 'test-lock')
      response.add(order_queue: 'test-lock')
      response.add(order_queue: 'test-lock-2')
      response.add
      expect(response.to_a).to include(
                                   hash_including(order_queue: 'test-lock', order: 1),
                                   hash_including(order_queue: 'test-lock', order: 2),
                                   hash_including(order_queue: 'test-lock-2', order: 1),
                                   hash_not_including(:order_queue, :order)
                               )
    end
  end

end
