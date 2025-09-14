require 'swagger_helper'

RSpec.describe 'Shows API', type: :request do
  path '/api/v1/shows' do
    get 'List shows' do
      tags 'Shows'
      produces 'application/json'
      parameter name: :movie_id, in: :query, type: :integer
      parameter name: :cinema_id, in: :query, type: :integer
      parameter name: :room_id, in: :query, type: :integer
      parameter name: :q, in: :query, type: :string
      parameter name: :sort, in: :query, type: :string
      parameter name: :page, in: :query, type: :integer
      parameter name: :per_page, in: :query, type: :integer

      response '200', 'shows listed' do
        run_test!
      end
    end

    post 'Create show' do
      tags 'Shows'
      consumes 'application/json'
      parameter name: :show, in: :body, schema: {
        type: :object,
        properties: {
          movie_id: { type: :integer },
          room_id: { type: :integer },
          cinema_id: { type: :integer },
          show_day: { type: :string, format: :date },
          ticket_price: { type: :number }
        },
        required: ['movie_id', 'room_id', 'cinema_id', 'show_day', 'ticket_price']
      }

      response '201', 'show created' do
        run_test!
      end

      response '422', 'invalid request' do
        let(:show) { { ticket_price: -1 } }
        run_test!
      end
    end
  end

  path '/api/v1/shows/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Show a show' do
      tags 'Shows'
      produces 'application/json'

      response '200', 'show found' do
        let(:id) { Show.create(movie_id: 1, room_id: 1, cinema_id: 1, show_day: Date.today, ticket_price: 100).id }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    put 'Update a show' do
      tags 'Shows'
      consumes 'application/json'
      parameter name: :show, in: :body, schema: {
        type: :object,
        properties: {
          show_day: { type: :string, format: :date },
          ticket_price: { type: :number }
        }
      }

      response '200', 'show updated' do
        let(:id) { Show.create(movie_id: 1, room_id: 1, cinema_id: 1, show_day: Date.today, ticket_price: 100).id }
        let(:show) { { ticket_price: 120 } }
        run_test!
      end

      response '422', 'invalid update' do
        let(:id) { Show.create(movie_id: 1, room_id: 1, cinema_id: 1, show_day: Date.today, ticket_price: 100).id }
        let(:show) { { ticket_price: -50 } }
        run_test!
      end
    end

    delete 'Delete a show' do
      tags 'Shows'

      response '204', 'show deleted' do
        let(:id) { Show.create(movie_id: 1, room_id: 1, cinema_id: 1, show_day: Date.today, ticket_price: 100).id }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { 0 }
        run_test!
      end
    end
  end
end
