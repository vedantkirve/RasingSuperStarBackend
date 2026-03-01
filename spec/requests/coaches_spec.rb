# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Coaches API', type: :request do
  path '/coaches' do
    post 'Creates a coach' do
      tags 'Coaches'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :coach, in: :body, schema: {
        type: :object,
        properties: {
          coach: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Coach Smith' },
              email: { type: :string, example: 'coach@example.com' },
              phone_number: { type: :string, example: '+1122334455' },
              zone_id: { type: :integer, example: 1 },
              start_time: { type: :string, example: '09:00', description: 'Time in HH:MM format' },
              end_time: { type: :string, example: '17:00', description: 'Time in HH:MM format' },
              status: { type: :string, enum: %w[active inactive], example: 'active' }
            },
            required: %w[name phone_number zone_id start_time end_time]
          }
        },
        required: ['coach']
      }

      response '201', 'coach created' do
        let(:zone) { Zone.create!(name: 'Zone B', status: 'active') }
        let(:coach) do
          {
            coach: {
              name: 'Coach Jones',
              email: 'jones@example.com',
              phone_number: '+1555666777',
              zone_id: zone.id,
              start_time: '10:00',
              end_time: '18:00',
              status: 'active'
            }
          }
        end
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :integer },
                     name: { type: :string },
                     email: { type: :string, nullable: true },
                     phone_number: { type: :string },
                     zone_id: { type: :integer },
                     start_time: { type: :string },
                     end_time: { type: :string },
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
          expect(data['data']['name']).to eq('Coach Jones')
        end
      end

      response '500', 'invalid request - missing required fields' do
        let(:coach) { { coach: { name: '', phone_number: '', zone_id: nil, start_time: '', end_time: '' } } }
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: false },
                 error: { type: :string }
               },
               required: %w[success error]
        run_test!
      end

      response '500', 'zone not found' do
        let(:coach) do
          {
            coach: {
              name: 'Coach X',
              phone_number: '+1111111111',
              zone_id: 999_999,
              start_time: '10:00',
              end_time: '18:00'
            }
          }
        end
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: false },
                 error: { type: :string }
               },
               required: %w[success error]
        run_test!
      end
    end
  end
end
