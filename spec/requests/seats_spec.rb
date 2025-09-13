# spec/requests/seats_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/seats', type: :request do
  path '/api/v1/seats' do
    get('list seats') do
      tags 'Seats'
      produces 'application/json'
      parameter name: :room_id, in: :query, type: :integer, description: 'Filter by room'

      response(200, 'successful') do
        run_test!
      end
    end

    post('create seat') do
      tags 'Seats'
      consumes 'application/json'
      parameter name: :seat, in: :body, schema: {
        type: :object,
        properties: {
          seat_number: { type: :integer },
          seat_row: { type: :string },
          room_id: { type: :integer }
        },
        required: %w[seat_number seat_row room_id]
      }

      response(201, 'seat created') do
        run_test!
      end
    end
  end

  path '/api/v1/seats/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Seat ID'

    get('show seat') do
      tags 'Seats'
      produces 'application/json'
      response(200, 'successful') do
        run_test!
      end
    end

    put('update seat') do
      tags 'Seats'
      consumes 'application/json'
      parameter name: :seat, in: :body, schema: {
        type: :object,
        properties: {
          seat_number: { type: :integer },
          seat_row: { type: :string },
          room_id: { type: :integer }
        }
      }

      response(200, 'seat updated') do
        run_test!
      end
    end

    delete('delete seat') do
      tags 'Seats'
      response(204, 'seat deleted') do
        run_test!
      end
    end
  end
end
