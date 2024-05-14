require "rails_helper"

describe "Buffet API" do
  context 'GET /api/v1/events?buffet_id:id' do
    it 'return all events and details for buffets_id' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini',
        corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      user.update!(buffet_id: buffet.id)
      event = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id, drinks: false, decoration: true,
        valet: false, only_local: false)
      event2 = Event.create!(name: 'Formatura',
        description: 'Formatura de alto padrão',
        min_qtd: 200, max_qtd: 400, duration: 250,
        menu: 'Doces, tortas, bolos e canapés',
        buffet_id: buffet.id, drinks: false, decoration: false,
        valet: false, only_local: false)
      price = Price.create!(base_price: 5000, sp_base_price:6000,
        sp_additional_person:500, additional_person:200, sp_extra_hour:30,
        extra_hour:20, event_id: event.id)
      price2 = Price.create!(base_price: 5000, sp_base_price:6000,
        sp_additional_person:500, additional_person:200, sp_extra_hour:30,
        extra_hour:20, event_id: event2.id)

      get "/api/v1/events?buffet_id=1"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2
      expect(json_response[0]["id"]).to eq 1
      expect(json_response[0]["name"]).to eq "Casamento"
      expect(json_response[0]["description"]).to eq "Serviço de mesa completo para casamentos"
      expect(json_response[0]["min_qtd"]).to eq 20
      expect(json_response[0]["max_qtd"]).to eq 40
      expect(json_response[0]["duration"]).to eq 250
      expect(json_response[0]["menu"]).to eq "Frutos do Mar"
      expect(json_response[0]["drinks"]).to eq false
      expect(json_response[0]["decoration"]).to eq true
      expect(json_response[0]["valet"]).to eq false
      expect(json_response[0]["only_local"]).to eq false
      expect(json_response[0]["prices"]["base_price"]).to eq 5000
      expect(json_response[0]["prices"]["additional_person"]).to eq 200
      expect(json_response[0]["prices"]["extra_hour"]).to eq 20
      expect(json_response[0]["prices"]["sp_base_price"]).to eq 6000
      expect(json_response[0]["prices"]["sp_additional_person"]).to eq 500
      expect(json_response[0]["prices"]["sp_extra_hour"]).to eq 30
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

    it 'and send invalid buffet_id and fails' do
      get "/api/v1/events?buffet_id=250"

      expect(response.status).to eq 406
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq "Buffet not found for this buffet_id"
    end
  end

  context 'GET /api/v1/events/id/check_date?date=yyyy-mm-dd&guest_qtd=int' do
    it 'and the event are available' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini',
        corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      user.update!(buffet_id: buffet.id)
      event = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250,
        menu: 'Frutos do Mar', buffet_id: buffet.id)
      price = Price.create!(base_price: 5000, sp_base_price:6000,
        sp_additional_person:500, additional_person:200,
        sp_extra_hour:30, extra_hour:20, event_id: event.id)

      get '/api/v1/events/1/check_date?date=2034-12-7&guest_qtd=30'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["value"]).to eq  7000
      expect(json_response["availability"]).to eq  true
    end

    it 'and the event are not available' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini',
        corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      user.update!(buffet_id: buffet.id)
      event = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id)
      price = Price.create!(base_price: 5000, sp_base_price:6000,
        sp_additional_person:500, additional_person:200, sp_extra_hour:30,
        extra_hour:20, event_id: event.id)
      album = Album.create!(event_id: event.id)
      album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
      price = Price.create!(base_price: 3000, sp_base_price:4000,
        sp_additional_person:400, additional_person:100, sp_extra_hour:60,
        extra_hour:50, event_id: event.id)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: Date.new(2034, 12, 7), estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :confirmed, final_price: 7000, extra_tax: 0,
        discount: 0, customer_id: customer.id, out_doors: false)

      get '/api/v1/events/1/check_date?date=2034-12-7&guest_qtd=30'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["value"]).to eq  0
      expect(json_response["availability"]).to eq  false
    end

    it 'and date are not informed' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini',
        corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      user.update!(buffet_id: buffet.id)
      event = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id)
      price = Price.create!(base_price: 5000, sp_base_price:6000,
        sp_additional_person:500, additional_person:200, sp_extra_hour:30,
        extra_hour:20, event_id: event.id)
      album = Album.create!(event_id: event.id)
      album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
      price = Price.create!(base_price: 3000, sp_base_price:4000,
        sp_additional_person:400, additional_person:100, sp_extra_hour:60,
        extra_hour:50, event_id: event.id)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: Date.new(2034, 12, 7), estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :confirmed, final_price: 7000, extra_tax: 0,
        discount: 0, customer_id: customer.id, out_doors: false)

      get '/api/v1/events/1/check_date?guest_qtd=30'

      expect(response.status).to eq 412
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq  "Date required for this operation"
    end

    it 'and date are in the past' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini',
        corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      user.update!(buffet_id: buffet.id)
      event = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id)
      price = Price.create!(base_price: 5000, sp_base_price:6000,
        sp_additional_person:500, additional_person:200, sp_extra_hour:30,
        extra_hour:20, event_id: event.id)
      album = Album.create!(event_id: event.id)
      album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
      price = Price.create!(base_price: 3000, sp_base_price:4000,
        sp_additional_person:400, additional_person:100, sp_extra_hour:60,
        extra_hour:50, event_id: event.id)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: Date.new(2034, 12, 7), estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :confirmed, final_price: 7000, extra_tax: 0,
        discount: 0, customer_id: customer.id, out_doors: false)

      get '/api/v1/events/1/check_date?date=2024-5-11&guest_qtd=30'

      expect(response.status).to eq 412
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq  "Date must be future"
    end

    it 'and guest quantity are not informed' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini',
        corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      user.update!(buffet_id: buffet.id)
      event = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id)
      price = Price.create!(base_price: 5000, sp_base_price:6000,
        sp_additional_person:500, additional_person:200, sp_extra_hour:30,
        extra_hour:20, event_id: event.id)
      album = Album.create!(event_id: event.id)
      album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
      price = Price.create!(base_price: 3000, sp_base_price:4000,
        sp_additional_person:400, additional_person:100, sp_extra_hour:60,
        extra_hour:50, event_id: event.id)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: Date.new(2034, 12, 7), estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :confirmed, final_price: 7000, extra_tax: 0,
        discount: 0, customer_id: customer.id, out_doors: false)

      get '/api/v1/events/1/check_date?date=2034-12-7'

      expect(response.status).to eq 412
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq  "Guest quantity required for this operation"
    end

    it 'and guest qtd are above event capacity' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini',
        corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      user.update!(buffet_id: buffet.id)
      event = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id)
      price = Price.create!(base_price: 5000, sp_base_price:6000,
        sp_additional_person:500, additional_person:200, sp_extra_hour:30,
        extra_hour:20, event_id: event.id)
      album = Album.create!(event_id: event.id)
      album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
      price = Price.create!(base_price: 3000, sp_base_price:4000,
        sp_additional_person:400, additional_person:100, sp_extra_hour:60,
        extra_hour:50, event_id: event.id)
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: Date.new(2034, 12, 7), estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :confirmed, final_price: 7000, extra_tax: 0,
        discount: 0, customer_id: customer.id, out_doors: false)

      get '/api/v1/events/1/check_date?date=2034-12-7&guest_qtd=50'

      expect(response.status).to eq 412
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq  "Guest quantity above max event's capacity"
    end

    it 'and send invalid id for event and fails' do
      get '/api/v1/events/250/check_date?date=2034-12-7&guest_qtd=30'

      expect(response.status).to eq 406
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response["error"]).to eq "Event not found for this id"
    end
  end
end