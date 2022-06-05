RSpec.describe 'Api/Doctors', type: :request do
  it 'returns all doctors without appointments' do
    2.times do
      FactoryBot.create(:doctor)
    end

    get '/api/doctors'
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body).length).to eq(2)
  end
end
