require 'swagger_helper'

RSpec.describe 'BookingSeats API', type: :request do
  path '/api/v1/booking_seats' do
    get 'List booking seats' do
      tags 'BookingSeats'
      produces 'application/json'
      parameter name: :booking_id, in: :query, type: :integer
      parameter name: :show_time_detail_id, in: :query, type: :integer
      parameter name: :hold_still, in: :query, type: :boolean
      parameter name: :page, in: :query, type: :integer
      parameter name: :per_page, in: :query, type: :integer
      parameter name: :sort, in: :query, type: :string

      response '200', 'booking seats listed' do
        run_test!
      end
    end

    post 'Create a booking seat' do
      tags 'BookingSeats'
      consumes 'application/json'
      parameter name: :booking_seat, in: :body, schema: {
        type: :object,
        properties: {
          booking_id: { type: :integer },
          seat_id: { type: :integer },
          show_time_detail_id: { type: :integer },
          hold_still: { type: :boolean }
        },
        required: ['booking_id','seat_id','show_time_detail_id','hold_still']
      }

      response '201', 'booking seat created' do
        run_test!
      end
    end
  end

  path '/api/v1/booking_seats/{id}' do
    get 'Retrieve a booking seat' do
      tags 'BookingSeats'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'booking seat found' do
        run_test!
      end
      response '404', 'booking seat not found' do
        run_test!
      end
    end

    put 'Update a booking seat' do
      tags 'BookingSeats'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :booking_seat, in: :body, schema: {
        type: :object,
        properties: {
          hold_still: { type: :boolean }
        }
      }

      response '200', 'booking seat updated' do
        run_test!
      end
    end

    delete 'Delete a booking seat' do
      tags 'BookingSeats'
      parameter name: :id, in: :path, type: :integer

      response '204', 'booking seat deleted' do
        run_test!
      end
    end
  end
end
