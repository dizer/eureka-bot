require 'spec_helper'

RSpec.describe EurekaBot::Controller::Response do

  context 'message order' do
    let(:response) { EurekaBot::Controller::Response.new }
    it do
      response.add
      response.add
      expect(response.to_a).to include(hash_including(eb_order: 1), hash_including(eb_order: 2))
    end
  end

end
