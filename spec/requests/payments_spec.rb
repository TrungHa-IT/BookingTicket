require 'swagger_helper'

RSpec.describe 'api/v1/payments', type: :request do
  path '/api/v1/payments' do
    get('list payments') do
      tags 'Payments'
      produces 'application/json'
      parameter name: :status, in: :query, type: :string, description: 'Filter by status'
      parameter name: :q, in: :query, type: :string, description: 'Search by user fullname'
      parameter name: :page, in: :query, type: :integer, description: 'Page number'
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page'

      response(200, 'successful') do
        run_test!
      end
    end

    post('create payment') do
      tags 'Payments'
      consumes 'application/json'
      parameter name: :payment, in: :body, schema: {
        type: :object,
        properties: {
          booking_id: { type: :integer },
          payment_method: { type: :string },
          amount: { type: :number },
          payment_date: { type: :string, format: :date_time },
          status: { type: :string }
        },
        required: %w[booking_id payment_method amount payment_date status]
      }

      response(201, 'created') do
        let(:payment) do
          {
            booking_id: 1,
            payment_method: 'Credit Card',
            amount: 200.0,
            payment_date: Time.now.iso8601,
            status: 'Success'
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/payments/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'payment id'

    get('show payment') do
      tags 'Payments'
      produces 'application/json'
      response(200, 'successful') do
        let(:id) { Payment.create!(booking_id: 1, payment_method: 'Momo', amount: 150, payment_date: Time.now, status: 'Pending').id }
        run_test!
      end
    end

    put('update payment') do
      tags 'Payments'
      consumes 'application/json'
      parameter name: :payment, in: :body, schema: {
        type: :object,
        properties: {
          status: { type: :string }
        }
      }
      response(200, 'updated') do
        let(:id) { Payment.create!(booking_id: 1, payment_method: 'Momo', amount: 150, payment_date: Time.now, status: 'Pending').id }
        let(:payment) { { status: 'Success' } }
        run_test!
      end
    end

    delete('delete payment') do
      tags 'Payments'
      response(204, 'no content') do
        let(:id) { Payment.create!(booking_id: 1, payment_method: 'Momo', amount: 150, payment_date: Time.now, status: 'Failed').id }
        run_test!
      end
    end
  end
end
