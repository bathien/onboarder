# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::OnboardersController, type: :controller do
  let(:valid_attributes) do
    {
      employee_id: 1,
      company_id: 1,
      start_date: Date.current,
      location: 'hcm',
      department: 'test',
      submitted_at: Time.zone.now
    }
  end

  let(:invalid_attributes) do
    {
      employee_id: 1,
      company_id: nil,
      start_date: Date.current,
      location: 'hcm',
      department: 'test'
    }
  end

  describe 'create onboarder' do
    context 'with valid params' do
      it 'creates a new Onboarder' do
        expect do
          post :create, params: { onboarder: valid_attributes }
        end.to change(Onboarder, :count).by(1)
      end

      it 'renders a JSON response with the new onboarder' do
        post :create, params: { onboarder: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new onboarder' do
        post :create, params: { onboarder: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'update onboarder' do
    context 'with valid params' do
      let(:new_attributes) do
        {
          employee_id: 1,
          company_id: 1,
          start_date: Date.current + 1.day,
          location: 'hcm',
          department: 'test',
          submitted_at: valid_attributes[:submitted_at] + 1.minutes
        }
      end

      it 'updates the requested onboarder' do
        onboarder = Onboarder.create! valid_attributes
        post :create, params: { onboarder: new_attributes }
        onboarder.reload
        expect(response).to have_http_status(:ok)
        expect(onboarder.start_date).to eq(new_attributes[:start_date])
      end

      it 'renders a JSON response with the onboarder' do
        Onboarder.create! valid_attributes

        post :create, params: { onboarder: valid_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end
    end
  end

  describe 'concurrency request onboarder' do
    it 'create the requested onboarder' do
      expect{
        expect(ActiveRecord::Base.connection.pool.size).to eq(5)
        concurrency_level = 4

        wait_for_it   = true

        threads = concurrency_level.times.map do |i|
          Thread.new do
            true while wait_for_it
            post :create, params: { onboarder: valid_attributes }
          rescue AbstractController::DoubleRenderError
          end
        end
        wait_for_it = false
        threads.each(&:join)
      }.to change {
        Onboarder.count
      }.by(1)
    ensure
      ActiveRecord::Base.connection_pool.disconnect!
    end

    it 'R1 create onboarder retry R2 update onboarder' do
      _r2 = post :create, params: { onboarder: valid_attributes.merge(submitted_at: Time.zone.now, start_date: Date.current) }
      _r1 = post :create, params: { onboarder: valid_attributes.merge(submitted_at: Time.zone.now - 1.minute, start_date: Date.tomorrow) }
      expect(Onboarder.count).to eq 1
      expect(Onboarder.first.start_date).to eq Date.current
    end

    it "update onboarder's start date miss-matched" do
      Onboarder.create! valid_attributes.merge(start_date: Date.yesterday)

      _r4 = post :create, params: { onboarder: valid_attributes.merge(submitted_at: valid_attributes[:submitted_at] + 10.seconds, start_date: Date.current) }
      _r3 = post :create, params: { onboarder: valid_attributes.merge(submitted_at: valid_attributes[:submitted_at] + 5.seconds, start_date: Date.tomorrow) }
      expect(Onboarder.count).to eq 1
      expect(Onboarder.first.start_date).to eq Date.current
    end
  end
end
