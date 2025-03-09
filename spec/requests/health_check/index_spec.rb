require 'rails_helper'

describe 'GET /health_check', type: :request do
  it '200を返すこと' do
    get '/health_check'
    expect(response).to have_http_status(:ok)
  end

  it 'returns an empty response body' do
    get '/health_check'
    expect(response.body).to be_empty
  end
end
