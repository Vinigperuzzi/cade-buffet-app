require "rails_helper"

describe "Buffet API" do
  context 'GET /api/v1/buffets' do
    it 'return all buffets ordered by name' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
      user.update!(buffet_id: buffet.id)

      user2 = User.create!(email: 'debora@email.com', password: 'password2')
      buffet2 = Buffet.create!(name: 'Dedi Delícias', corporate_name: 'Amaral eventos LTDA', 
                          register_number: '32156456000145', phone: '53 991535353', email: 'dedi@delicias.com',
                          address: 'Marechal Deodoro, 200', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Pix, Dinheiro', description: 'O evento mais elegante da região')
      user2.update!(buffet_id: buffet2.id)

      get "/api/v1/buffets"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2
      expect(json_response[0]["name"]).to eq "Dedi Delícias"
      expect(json_response[0]["id"]).to eq 2
      expect(json_response[1]["name"]).to eq "Vini"
      expect(json_response[1]["id"]).to eq 1
    end

    it 'and return buffets by matching search word' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
      user.update!(buffet_id: buffet.id)

      user2 = User.create!(email: 'debora@email.com', password: 'password2')
      buffet2 = Buffet.create!(name: 'Dedi Delícias', corporate_name: 'Amaral eventos LTDA', 
                          register_number: '32156456000145', phone: '53 991535353', email: 'dedi@delicias.com',
                          address: 'Marechal Deodoro, 200', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Pix, Dinheiro', description: 'O evento mais elegante da região')
      user2.update!(buffet_id: buffet2.id)

      get "/api/v1/buffets?query=Vini"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 1
      expect(json_response[0]["name"]).to eq "Vini"
      expect(json_response[0]["id"]).to eq 1
    end

    it "and return empty if there's no buffet" do
      get "/api/v1/buffets"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end
  end
end