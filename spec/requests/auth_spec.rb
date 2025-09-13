require 'swagger_helper'

RSpec.describe 'api/v1/auth', type: :request do
  path '/api/v1/login' do
    post 'Login to get token' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: "a@gmail.com" },
          password: { type: :string, example: "123456" }
        },
        required: ['email', 'password']
      }

      response '200', 'Login successfull' do
        let!(:user) { User.create!(fullname: "Nguyen Van A", email: "a@gmail.com", password_hash: "123456", role: "user") }
        let(:credentials) { { email: user.email, password: "123456" } }
        run_test!
      end

      response '401', 'Email or Password incorrect' do
        let(:credentials) { { email: "wrong@gmail.com", password: "wrong" } }
        run_test!
      end
    end
  end

  path '/api/v1/register' do
    post 'Register and get JWT token' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          fullname: { type: :string, example: "Nguyen Van B" },
          email: { type: :string, example: "b@gmail.com" },
          phone: { type: :string, example: "0901234567" },
          password_hash: { type: :string, example: "123456" },
          role: { type: :integer, example: 0 }
        },
        required: ['fullname', 'email', 'phone', 'password_hash', 'role']
      }

      response '201', 'Register successfull' do
        let(:user) { { fullname: "Nguyen Van B", email: "b@gmail.com", phone: "0901234567", password_hash: "123456", role: 0 } }
        run_test!
      end

      response '422', 'Data incorrect' do
        let(:user) { { fullname: "", email: "sai", phone: "abc", password_hash: "", role: 1 } }
        run_test!
      end
    end
  end
end
