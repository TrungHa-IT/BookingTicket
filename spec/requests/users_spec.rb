# spec/requests/api/v1/users_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/users' do
    get 'List users' do
      tags 'Users'
      produces 'application/json'
      parameter name: :q, in: :query, type: :string, description: 'Search keyword'
      parameter name: :role, in: :query, type: :integer, description: 'Filter by role'
      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page'
      parameter name: :sort, in: :query, type: :string, description: 'Sort field, prefix with - for desc'

      response '200', 'users found' do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       fullname: { type: :string },
                       email: { type: :string },
                       phone: { type: :string },
                       role: { type: :integer },
                       created_at: { type: :string, format: 'date-time' }
                     }
                   }
                 },
                 meta: { type: :object }
               }

        before { create_list(:user, 3) } # dùng factory_bot
        run_test!
      end
    end

    post 'Create user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          fullname: { type: :string },
          email: { type: :string },
          phone: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string },
          role: { type: :integer }
        },
        required: %w[fullname email phone password password_confirmation]
      }

      response '201', 'user created' do
        let(:user) do
          {
            fullname: 'Nguyen Van A',
            email: 'a@gmail.com',
            phone: '0901234567',
            password: '123456',
            password_confirmation: '123456',
            role: 1
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    parameter name: :id, in: :path, type: :string

    get 'Show user' do
      tags 'Users'
      produces 'application/json'
      response '200', 'user found' do
        let(:id) { create(:user).id }
        run_test!
      end
      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Update user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          fullname: { type: :string },
          phone: { type: :string },
          role: { type: :integer }
        }
      }
      response '200', 'user updated' do
        let(:id) { create(:user).id }
        let(:user) { { fullname: 'Updated name' } }
        run_test!
      end
    end

    delete 'Delete user' do
      tags 'Users'
      response '204', 'user deleted' do
        let(:id) { create(:user).id }
        run_test!
      end
    end
  end
end
