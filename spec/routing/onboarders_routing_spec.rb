# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::OnboardersController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: 'api/onboarders/create').to route_to('api/onboarders#create')
    end
  end
end
