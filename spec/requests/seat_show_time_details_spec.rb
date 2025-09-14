require 'swagger_helper'

RSpec.describe 'SeatShowTimeDetails API', type: :request do
  path '/api/v1/seat_show_time_details' do
    get 'List seat show time details' do
      tags 'SeatShowTimeDetails'
      produces 'application/json'
      parameter name: :show_time_detail_id, in: :query, type: :integer
      parameter name: :seat_id, in: :query, type: :integer
      parameter name: :status, in: :query, type: :string
      parameter name: :sort, in: :query, type: :string
      parameter name: :page, in: :query, type: :integer
      parameter name: :per_page, in: :query, type: :integer

      response '200', 'seat show time details listed' do
        run_test!
      end
    end

    post 'Create seat show time detail' do
      tags 'SeatShowTimeDetails'
      consumes 'application/json'
      parameter name: :seat_show_time_detail, in: :body, schema: {
        type: :object,
        properties: {
          show_time_detail_id: { type: :integer },
          seat_id: { type: :integer },
          status: { type: :string, enum: ["Available", "Booked", "Held"] }
        },
        required: ['show_time_detail_id', 'seat_id', 'status']
      }

      response '201', 'seat show time detail created' do
        run_test!
      end

      response '422', 'invalid request' do
        let(:seat_show_time_detail) { { status: '' } }
        run_test!
      end
    end
  end

  path '/api/v1/seat_show_time_details/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Show seat show time detail' do
      tags 'SeatShowTimeDetails'
      produces 'application/json'

      response '200', 'seat show time detail found' do
        let(:id) { SeatShowTimeDetail.create(show_time_detail_id: 1, seat_id: 1, status: "Available").id }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    put 'Update seat show time detail' do
      tags 'SeatShowTimeDetails'
      consumes 'application/json'
      parameter name: :seat_show_time_detail, in: :body, schema: {
        type: :object,
        properties: {
          status: { type: :string, enum: ["Available", "Booked", "Held"] }
        }
      }

      response '200', 'seat show time detail updated' do
        let(:id) { SeatShowTimeDetail.create(show_time_detail_id: 1, seat_id: 2, status: "Available").id }
        let(:seat_show_time_detail) { { status: "Booked" } }
        run_test!
      end

      response '422', 'invalid update' do
        let(:id) { SeatShowTimeDetail.create(show_time_detail_id: 1, seat_id: 3, status: "Available").id }
        let(:seat_show_time_detail) { { status: "Invalid" } }
        run_test!
      end
    end

    delete 'Delete seat show time detail' do
      tags 'SeatShowTimeDetails'

      response '204', 'seat show time detail deleted' do
        let(:id) { SeatShowTimeDetail.create(show_time_detail_id: 1, seat_id: 4, status: "Available").id }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { 0 }
        run_test!
      end
    end
  end
end
