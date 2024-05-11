require "rails_helper"

describe "Buffet API" do
  context 'GET /api/v1/events?buffet_id:id' do
    it 'return all events and details for buffets_id' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                            register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                            address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                            payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
      user.update!(buffet_id: buffet.id)
      event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                              duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
      event2 = Event.create!(name: 'Formatura', description: 'Formatura de alto padrão', min_qtd: 200, max_qtd: 400,
                                duration: 250, menu: 'Doces, tortas, bolos e canapés', buffet_id: buffet.id)

      get "/api/v1/events?buffet_id=1"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2
      expect(json_response[0]["name"]).to eq "Casamento"
      expect(json_response[0]["id"]).to eq 1
      expect(json_response[0]["description"]).to eq "Serviço de mesa completo para casamentos"
      expect(json_response[1]["name"]).to eq "Formatura"
      expect(json_response[1]["id"]).to eq 2
      expect(json_response[1]["description"]).to eq "Formatura de alto padrão"
    end

    it 'and do not send buffet_id and fails' do
      get "/api/v1/events"

      expect(response.status).to eq 412
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq "Buffet_id required for this operation"
    end

    it 'and do not send buffet_id and fails' do
      get "/api/v1/events?buffet_id=250"

      expect(response.status).to eq 406
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq "Buffet not found for this buffet_id"
    end
  end
end