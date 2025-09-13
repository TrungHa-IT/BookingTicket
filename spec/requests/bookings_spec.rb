require 'swagger_helper'

RSpec.describe 'Bookings API', type: :request do
  path '/api/v1/bookings' do
    get 'List bookings' do
      tags 'Bookings'
      produces 'application/json'
      parameter name: :user_id, in: :query, type: :integer
      parameter name: :show_id, in: :query, type: :integer
      parameter name: :status, in: :query, type: :string
      parameter name: :q, in: :query, type: :string
      parameter name: :page, in: :query, type: :integer
      parameter name: :per_page, in: :query, type: :integer

      response '200', 'bookings listed' do
        run_test!
      end
    end

    post 'Create booking' do
      tags 'Bookings'
      consumes 'application/json'
      parameter name: :booking, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          show_id: { type: :integer },
          total_amount: { type: :number },
          status: { type: :string }
        },
        required: ['user_id','show_id','total_amount','status']
      }

      response '201', 'booking created' do
        run_test!
      end
    end
  end
end
