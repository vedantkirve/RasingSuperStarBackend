# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Zones API', type: :request do
  path '/zones' do
    post 'Creates a zone' do
      tags 'Zones'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :zone, in: :body, schema: {
        type: :object,
        properties: {
          zone: {
            type: :object,
            properties: {
              name: { type: :string, example: 'Zone A' },
              description: { type: :string, example: 'Description of the zone' },
              status: { type: :string, enum: %w[active inactive], example: 'active' }
            },
            required: ['name']
          }
        },
        required: ['zone']
      }

      response '201', 'zone created' do
        let(:zone) { { zone: { name: 'Test Zone', description: 'A test zone', status: 'active' } } }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to eq(true)
          expect(data['data']).to have_key('id')
          expect(data['data']['name']).to eq('Test Zone')
        end
      end

      response '500', 'invalid request' do
        let(:zone) { { zone: { name: '' } } }
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: false },
                 error: { type: :string }
               },
               required: %w[success error]
        run_test!
      end
    end

    get 'Lists zones' do
      tags 'Zones'
      produces 'application/json'

      response '200', 'zones list' do
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string },
                       description: { type: :string, nullable: true },
                       status: { type: :string },
                       created_at: { type: :string, format: 'date-time' },
                       updated_at: { type: :string, format: 'date-time' }
                     }
                   }
                 }
               },
               required: %w[success data]

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to eq(true)
          expect(data['data']).to be_an(Array)
        end
      end
    end
  end
end
