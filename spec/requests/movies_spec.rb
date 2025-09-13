# spec/requests/movies_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/movies', type: :request do
  path '/api/v1/movies' do
    get('list movies') do
      tags 'Movies'
      produces 'application/json'
      parameter name: :q, in: :query, type: :string, description: 'Search by title'
      parameter name: :status, in: :query, type: :string, description: 'Filter by status'
      parameter name: :limit_age, in: :query, type: :integer, description: 'Filter by age'

      response(200, 'successful') do
        run_test!
      end
    end

    post('create movie') do
      tags 'Movies'
      consumes 'application/json'
      parameter name: :movie, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          duration_minutes: { type: :integer },
          status: { type: :string },
          limit_age: { type: :integer },
          screening_day: { type: :string, format: 'date' }
        },
        required: %w[title duration_minutes status limit_age screening_day]
      }

      response(201, 'movie created') do
        run_test!
      end
    end
  end

  path '/api/v1/movies/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Movie ID'

    get('show movie') do
      tags 'Movies'
      produces 'application/json'
      response(200, 'successful') do
        run_test!
      end
    end

    put('update movie') do
      tags 'Movies'
      consumes 'application/json'
      parameter name: :movie, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          duration_minutes: { type: :integer },
          status: { type: :string },
          limit_age: { type: :integer },
          screening_day: { type: :string, format: 'date' }
        }
      }

      response(200, 'movie updated') do
        run_test!
      end
    end

    delete('delete movie') do
      tags 'Movies'
      response(204, 'movie deleted') do
        run_test!
      end
    end
  end
end
