require 'swagger_helper'

RSpec.describe 'ShowTimeDetails API', type: :request do
  path '/api/v1/show_time_details' do
    get 'List show time details' do
      tags 'ShowTimeDetails'
      produces 'application/json'
      parameter name: :show_id, in: :query, type: :integer
      parameter name: :sort, in: :query, type: :string
      parameter name: :page, in: :query, type: :integer
      parameter name: :per_page, in: :query, type: :integer

      response '200', 'show_time_details listed' do
        run_test!
      end
    end

    post 'Create show time detail' do
      tags 'ShowTimeDetails'
      consumes 'application/json'
      parameter name: :show_time_detail, in: :body, schema: {
        type: :object,
        properties: {
          show_id: { type: :integer },
          start_time: { type: :string, format: :date_time },
          end_time: { type: :string, format: :date_time }
        },
        required: ['show_id', 'start_time', 'end_time']
      }

      response '201', 'show_time_detail created' do
        run_test!
      end

      response '422', 'invalid request' do
        let(:show_time_detail) { { start_time: Time.now, end_time: Time.now - 1.hour } }
        run_test!
      end
    end
  end

  path '/api/v1/show_time_details/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Show a show time detail' do
      tags 'ShowTimeDetails'
      produces 'application/json'

      response '200', 'show_time_detail found' do
        let(:id) { ShowTimeDetail.create(show_id: 1, start_time: Time.now, end_time: Time.now + 2.hours).id }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    put 'Update a show time detail' do
      tags 'ShowTimeDetails'
      consumes 'application/json'
      parameter name: :show_time_detail, in: :body, schema: {
        type: :object,
        properties: {
          start_time: { type: :string, format: :date_time },
          end_time: { type: :string, format: :date_time }
        }
      }

      response '200', 'show_time_detail updated' do
        let(:id) { ShowTimeDetail.create(show_id: 1, start_time: Time.now, end_time: Time.now + 2.hours).id }
        let(:show_time_detail) { { end_time: Time.now + 3.hours } }
        run_test!
      end

      response '422', 'invalid update' do
        let(:id) { ShowTimeDetail.create(show_id: 1, start_time: Time.now, end_time: Time.now + 2.hours).id }
        let(:show_time_detail) { { end_time: Time.now - 1.hour } }
        run_test!
      end
    end

    delete 'Delete a show time detail' do
      tags 'ShowTimeDetails'

      response '204', 'show_time_detail deleted' do
        let(:id) { ShowTimeDetail.create(show_id: 1, start_time: Time.now, end_time: Time.now + 2.hours).id }
        run_test!
      end

      response '404', 'not found' do
        let(:id) { 0 }
        run_test!
      end
    end
  end
end
