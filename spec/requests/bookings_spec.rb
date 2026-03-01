# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Bookings API', type: :request do
  path '/bookings' do
    post 'Creates a booking' do
      tags 'Bookings'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :booking, in: :body, schema: {
        type: :object,
        properties: {
          booking: {
            type: :object,
            properties: {
              user_id: { type: :integer, example: 1 },
              zone_id: { type: :integer, example: 1 },
              session_date: { type: :string, example: '2026-03-15', description: 'Date in YYYY-MM-DD format' },
              start_time: { type: :string, example: '10:00', description: 'Time in HH:MM format' }
            },
            required: %w[user_id zone_id session_date start_time]
          }
        },
        required: ['booking']
      }

      response '201', 'booking created' do
        let(:zone) { Zone.create!(name: 'Zone C', status: 'active') }
        let(:user) { User.create!(name: 'Booker', phone_number: '+1999888777') }
        let(:coach) do
          Coach.create!(
            name: 'Coach Lee',
            phone_number: '+1222333444',
            zone: zone,
            start_time: '09:00',
            end_time: '19:00',
            status: 'active'
          )
        end
        let(:booking) do
          {
            booking: {
              user_id: user.id,
              zone_id: zone.id,
              session_date: (Time.zone.today + 1.day).strftime('%Y-%m-%d'),
              start_time: '10:00'
            }
          }
        end

        before { coach }

        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     user_id: { type: :integer },
                     coach_id: { type: :integer },
                     session_date: { type: :string },
                     start_time: { type: :string },
                     end_time: { type: :string },
                     state: { type: :string },
                     status: { type: :string },
                     created_at: { type: :string, format: 'date-time' },
                     updated_at: { type: :string, format: 'date-time' }
                   }
                 }
               },
               required: %w[success data]

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to eq(true)
          expect(data['data']).to have_key('id')
          expect(data['data']['state']).to eq('confirmed')
        end
      end

      response '500', 'invalid request - missing required fields' do
        let(:booking) { { booking: { user_id: nil, zone_id: nil, session_date: '', start_time: '' } } }
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: false },
                 error: { type: :string }
               },
               required: %w[success error]
        run_test!
      end

      response '500', 'no coach available' do
        let(:zone) { Zone.create!(name: 'Zone No Coach', status: 'active') }
        let(:user) { User.create!(name: 'User', phone_number: '+1333444555') }
        let(:booking) do
          {
            booking: {
              user_id: user.id,
              zone_id: zone.id,
              session_date: (Time.zone.today + 1.day).strftime('%Y-%m-%d'),
              start_time: '10:00'
            }
          }
        end
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: false },
                 error: { type: :string }
               },
               required: %w[success error]
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to eq(false)
        end
      end
    end
  end
end
