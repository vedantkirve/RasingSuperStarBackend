# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Availability API', type: :request do
  path '/availability' do
    get 'Returns availability for a zone' do
      tags 'Availability'
      produces 'application/json'
      parameter name: :zone_id, in: :query, type: :integer, required: true,
                description: 'Zone ID to get availability for'

      response '200', 'availability for zone' do
        let(:zone_id) { Zone.create!(name: 'Zone A', status: 'active').id }
        schema type: :object,
               properties: {
                 success: { type: :boolean, example: true },
                 availability: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       date: { type: :string, example: '2026-03-01' },
                       slots: {
                         type: :array,
                         items: {
                           type: :object,
                           properties: {
                             start_time: { type: :string, example: '10:00' },
                             end_time: { type: :string, example: '11:30' }
                           }
                         }
                       }
                     }
                   }
                 }
               },
               required: %w[success availability]

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to eq(true)
          expect(data['availability']).to be_an(Array)
        end
      end

      response '200', 'empty availability when zone has no coaches' do
        let(:zone_id) { Zone.create!(name: 'Empty Zone', status: 'active').id }
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to eq(true)
          expect(data['availability']).to eq([])
        end
      end
    end
  end
end
