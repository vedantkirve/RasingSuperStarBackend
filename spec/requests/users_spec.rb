# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/users' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string, example: 'John Doe' },
              email: { type: :string, example: 'john@example.com' },
              phone_number: { type: :string, example: '+1234567890' },
              status: { type: :string, enum: %w[active inactive], example: 'active' }
            },
            required: %w[name phone_number]
          }
        },
        required: ['user']
      }

      response '201', 'user created' do
        let(:user) do
          { user: { name: 'Jane Doe', email: 'jane@example.com', phone_number: '+1987654321', status: 'active' } }
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
          expect(data['data']['name']).to eq('Jane Doe')
        end
      end

      response '500', 'invalid request - missing required fields' do
        let(:user) { { user: { name: '', phone_number: '' } } }
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
