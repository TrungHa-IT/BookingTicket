require 'swagger_helper'

RSpec.describe 'Cinemas API', type: :request do
  path '/api/v1/cinemas' do
    get 'List cinemas' do
      tags 'Cinemas'
      produces 'application/json'
      parameter name: :q, in: :query, type: :string
      parameter name: :sort, in: :query, type: :string
      parameter name: :page, in: :query, type: :integer
      parameter name: :per_page, in: :query, type: :integer

      response '200', 'cinemas listed' do
        run_test!
      end
    end

    post 'Create cinema' do
      tags 'Cinemas'
      consumes 'application/json'
      parameter name: :cinema, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          address: { type: :string }
        },
        required: ['name','address']
      }

      response '201', 'cinema created' do
        run_test!
      end
    end
  end

  path '/api/v1/cinemas/{id}' do
    get 'Retrieve cinema' do
      tags 'Cinemas'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'cinema found' do
        let(:id) { Cinema.create(name: "CGV", address: "123 Street").id }
        run_test!
      end
    end

    patch 'Update cinema' do
      tags 'Cinemas'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :cinema, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          address: { type: :string }
        }
      }

      response '200', 'cinema updated' do
        let(:id) { Cinema.create(name: "CGV", address: "123 Street").id }
        run_test!
      end
    end

    delete 'Delete cinema' do
      tags 'Cinemas'
      parameter name: :id, in: :path, type: :integer

      response '204', 'cinema deleted' do
        let(:id) { Cinema.create(name: "CGV", address: "123 Street").id }
        run_test!
      end
    end
  end
end
