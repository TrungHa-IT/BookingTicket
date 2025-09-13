require 'swagger_helper'

RSpec.describe 'Genres API', type: :request do
  path '/api/v1/genres' do
    get 'List genres' do
      tags 'Genres'
      produces 'application/json'
      parameter name: :q, in: :query, type: :string
      parameter name: :sort, in: :query, type: :string
      parameter name: :page, in: :query, type: :integer
      parameter name: :per_page, in: :query, type: :integer

      response '200', 'genres listed' do
        run_test!
      end
    end

    post 'Create genre' do
      tags 'Genres'
      consumes 'application/json'
      parameter name: :genre, in: :body, schema: {
        type: :object,
        properties: {
          genre_name: { type: :string },
          genre_description: { type: :string }
        },
        required: ['genre_name', 'genre_description']
      }

      response '201', 'genre created' do
        run_test!
      end

      response '422', 'invalid request' do
        let(:genre) { { genre_name: '' } }
        run_test!
      end
    end
  end

  path '/api/v1/genres/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Show genre' do
      tags 'Genres'
      produces 'application/json'

      response '200', 'genre found' do
        let(:id) { Genre.create(genre_name: 'Action', genre_description: 'Action movies').id }
        run_test!
      end

      response '404', 'genre not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    put 'Update genre' do
      tags 'Genres'
      consumes 'application/json'
      parameter name: :genre, in: :body, schema: {
        type: :object,
        properties: {
          genre_name: { type: :string },
          genre_description: { type: :string }
        }
      }

      response '200', 'genre updated' do
        let(:id) { Genre.create(genre_name: 'Comedy', genre_description: 'Funny movies').id }
        let(:genre) { { genre_name: 'Comedy Updated', genre_description: 'Updated description' } }
        run_test!
      end

      response '422', 'invalid update' do
        let(:id) { Genre.create(genre_name: 'Horror', genre_description: 'Horror movies').id }
        let(:genre) { { genre_name: '' } }
        run_test!
      end
    end

    delete 'Delete genre' do
      tags 'Genres'
      response '204', 'genre deleted' do
        let(:id) { Genre.create(genre_name: 'Thriller', genre_description: 'Thriller movies').id }
        run_test!
      end

      response '404', 'genre not found' do
        let(:id) { 0 }
        run_test!
      end
    end
  end
end
