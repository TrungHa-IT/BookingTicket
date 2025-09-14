require 'swagger_helper'

RSpec.describe 'Rooms API', type: :request do
  path '/api/v1/rooms' do
    get 'List rooms' do
      tags 'Rooms'
      produces 'application/json'
      parameter name: :cinema_id, in: :query, type: :integer
      parameter name: :q, in: :query, type: :string
      parameter name: :sort, in: :query, type: :string
      parameter name: :page, in: :query, type: :integer
      parameter name: :per_page, in: :query, type: :integer

      response '200', 'rooms listed' do
        run_test!
      end
    end

    post 'Create room' do
      tags 'Rooms'
      consumes 'application/json'
      parameter name: :room, in: :body, schema: {
        type: :object,
        properties: {
          cinema_id: { type: :integer },
          name: { type: :string },
          seat_capacity: { type: :integer }
        },
        required: ['cinema_id', 'name', 'seat_capacity']
      }

      response '201', 'room created' do
        run_test!
      end

      response '422', 'invalid request' do
        let(:room) { { name: '' } }
        run_test!
      end
    end
  end

  path '/api/v1/rooms/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Show room' do
      tags 'Rooms'
      produces 'application/json'

      response '200', 'room found' do
        let(:id) { Room.create(cinema_id: 1, name: 'Room 1', seat_capacity: 100).id }
        run_test!
      end

      response '404', 'room not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    put 'Update room' do
      tags 'Rooms'
      consumes 'application/json'
      parameter name: :room, in: :body, schema: {
        type: :object,
        properties: {
          cinema_id: { type: :integer },
          name: { type: :string },
          seat_capacity: { type: :integer }
        }
      }

      response '200', 'room updated' do
        let(:id) { Room.create(cinema_id: 1, name: 'Room 2', seat_capacity: 80).id }
        let(:room) { { name: 'Room 2 Updated', seat_capacity: 90 } }
        run_test!
      end

      response '422', 'invalid update' do
        let(:id) { Room.create(cinema_id: 1, name: 'Room 3', seat_capacity: 50).id }
        let(:room) { { seat_capacity: -10 } }
        run_test!
      end
    end

    delete 'Delete room' do
      tags 'Rooms'

      response '204', 'room deleted' do
        let(:id) { Room.create(cinema_id: 1, name: 'Room 4', seat_capacity: 70).id }
        run_test!
      end

      response '404', 'room not found' do
        let(:id) { 0 }
        run_test!
      end
    end
  end
end
