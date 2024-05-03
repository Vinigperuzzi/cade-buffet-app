require "rails_helper"

describe "User see order's list" do

  it "and do not see a 'Realizar Pedido' button" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000, sp_additional_person:500,
                          additional_person:200, sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')

    login_as user, scope: :user
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Mostrar Detalhes'

    expect(page).not_to have_button 'Realizar Pedido'
  end

  it "and cannot force url for other user's order's details" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000, sp_additional_person:500,
                          additional_person:200, sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')

    user2 = User.create!(email: 'debora@email.com', password: 'password2')
    buffet2 = Buffet.create!(name: 'Dedi Eventos', corporate_name: 'Amaral Debora Eventos LTDA', 
                          register_number: '23487456000145', phone: '53 991535353', email: 'contato@eventosdedi.com',
                          address: 'Rua Andrade Neves, 300', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Pix, Dinheiro', description: 'Eventos tradicionalistas para a primeira capital farroupilha.')
    user2.update!(buffet_id: buffet2.id)
    event2 = Event.create!(name: 'Formatura', description: 'Evento para solenidades', min_qtd: 60, max_qtd: 80,
                            duration: 320, menu: 'Canapés', buffet_id: buffet2.id)
    price = Price.create!(base_price: 3000, sp_base_price:4000, sp_additional_person:250,
                          additional_person:150, sp_extra_hour:50, extra_hour:60, event_id: event2.id)
    album2 = Album.create!(event_id: event2.id)
    album2.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')

    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente1', cpf: '479.111.310-15')

    order1 = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: 1.day.from_now, estimated_qtd: 30,
                        event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                        final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)
    order1.valid?
    order2 = Order.create!(buffet_id: buffet2.id, event_id: event2.id, event_date: 1.day.from_now, estimated_qtd: 70,
                        event_details: 'Quero temática Geek para a formatura em Ciência da Computação', address: '', order_status: :waiting,
                        final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)
    order2.valid?

    login_as user, scope: :user
    visit order_path(order2.id)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não pode ver detalhes de pedidos de outras pessoas.'
  end

  it "and only see orders for own events" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000, sp_additional_person:500,
                          additional_person:200, sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')

    user2 = User.create!(email: 'debora@email.com', password: 'password2')
    buffet2 = Buffet.create!(name: 'Dedi Eventos', corporate_name: 'Amaral Debora Eventos LTDA', 
                          register_number: '23487456000145', phone: '53 991535353', email: 'contato@eventosdedi.com',
                          address: 'Rua Andrade Neves, 300', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Pix, Dinheiro', description: 'Eventos tradicionalistas para a primeira capital farroupilha.')
    user2.update!(buffet_id: buffet2.id)
    event2 = Event.create!(name: 'Formatura', description: 'Evento para solenidades', min_qtd: 60, max_qtd: 80,
                            duration: 320, menu: 'Canapés', buffet_id: buffet2.id)
    price = Price.create!(base_price: 3000, sp_base_price:4000, sp_additional_person:250,
                          additional_person:150, sp_extra_hour:50, extra_hour:60, event_id: event2.id)
    album2 = Album.create!(event_id: event2.id)
    album2.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')

    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente1', cpf: '479.111.310-15')

    order1 = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: 1.day.from_now, estimated_qtd: 30,
                        event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                        final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)
    order1.valid?
    order2 = Order.create!(buffet_id: buffet2.id, event_id: event2.id, event_date: 1.day.from_now, estimated_qtd: 70,
                        event_details: 'Quero temática Geek para a formatura em Ciência da Computação', address: '', order_status: :waiting,
                        final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)
    order2.valid?

    login_as user, scope: :user
    visit root_path
    click_on 'Pedidos'
    
    expect(page).to have_content order1.code
    expect(page).not_to have_content order2.code
  end

  it "and see the pending ones first" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000, sp_additional_person:500,
                          additional_person:200, sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    event2 = Event.create!(name: 'Formatura', description: 'Serviço de mesa completo para formaturas', min_qtd: 200, max_qtd: 400,
                            duration: 350, menu: 'Canapés', buffet_id: buffet.id)
    price = Price.create!(base_price: 3000, sp_base_price:4000, sp_additional_person:400,
                          additional_person:100, sp_extra_hour:60, extra_hour:50, event_id: event2.id)
    album2 = Album.create!(event_id: event2.id)
    album2.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
    customer2 = Customer.create!(email: 'cliente2@email.com', password: 'password2', name: 'cliente2', cpf: '010.279.200-39')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: 1.day.from_now, estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)
    order2 = Order.create!(buffet_id: buffet.id, event_id: event2.id, event_date: 2.day.from_now, estimated_qtd: 300,
                          event_details: 'Se possível, colocar uma pessoa vestida de Han Solo para recepcionar', address: '', order_status: :waiting,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer2.id, out_doors: false)
    
    login_as user, scope: :user
    visit root_path
    click_on 'Pedidos'
    
    within('[class="event-card-container pending-events"]') do
      within('div.event-card:nth-child(1)') do
        date = I18n.localize(order.event_date)
        expect(page).to have_content date
        expect(page).to have_content order.code
      end
      within('div.event-card:nth-child(2)') do
        date = I18n.localize(order2.event_date)
        expect(page).to have_content date
        expect(page).to have_content order2.code
      end
    end
  end

  it "and see the pending in ordered by date (my own feature)" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000, sp_additional_person:500,
                          additional_person:200, sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    event2 = Event.create!(name: 'Formatura', description: 'Serviço de mesa completo para formaturas', min_qtd: 200, max_qtd: 400,
                            duration: 350, menu: 'Canapés', buffet_id: buffet.id)
    price = Price.create!(base_price: 3000, sp_base_price:4000, sp_additional_person:400,
                          additional_person:100, sp_extra_hour:60, extra_hour:50, event_id: event2.id)
    album2 = Album.create!(event_id: event2.id)
    album2.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
    customer2 = Customer.create!(email: 'cliente2@email.com', password: 'password2', name: 'cliente2', cpf: '010.279.200-39')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: 4.day.from_now, estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)
    order2 = Order.create!(buffet_id: buffet.id, event_id: event2.id, event_date: 1.day.from_now, estimated_qtd: 300,
                          event_details: 'Se possível, colocar uma pessoa vestida de Han Solo para recepcionar', address: '', order_status: :waiting,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer2.id, out_doors: false)
    
    login_as user, scope: :user
    visit root_path
    click_on 'Pedidos'
    
    within('[class="event-card-container pending-events"]') do
      within('div.event-card:nth-child(1)') do
        date = I18n.localize(order2.event_date)
        expect(page).to have_content date
        expect(page).to have_content order2.code
      end
      within('div.event-card:nth-child(2)') do
        date = I18n.localize(order.event_date)
        expect(page).to have_content date
        expect(page).to have_content order.code
      end
    end
  end

  it "and see the general ones last" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000, sp_additional_person:500,
                          additional_person:200, sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    event2 = Event.create!(name: 'Formatura', description: 'Serviço de mesa completo para formaturas', min_qtd: 200, max_qtd: 400,
                            duration: 350, menu: 'Canapés', buffet_id: buffet.id)
    price = Price.create!(base_price: 3000, sp_base_price:4000, sp_additional_person:400,
                          additional_person:100, sp_extra_hour:60, extra_hour:50, event_id: event2.id)
    album2 = Album.create!(event_id: event2.id)
    album2.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
    customer2 = Customer.create!(email: 'cliente2@email.com', password: 'password2', name: 'cliente2', cpf: '010.279.200-39')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: 4.day.from_now, estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)
    order2 = Order.create!(buffet_id: buffet.id, event_id: event2.id, event_date: 1.day.from_now, estimated_qtd: 300,
                          event_details: 'Se possível, colocar uma pessoa vestida de Han Solo para recepcionar', address: '', order_status: :evaluated,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer2.id, out_doors: false)
    
    login_as user, scope: :user
    visit root_path
    click_on 'Pedidos'
    
    within('[class="event-card-container pending-events"]') do
      within('div.event-card:nth-child(1)') do
        date = I18n.localize(order.event_date)
        expect(page).to have_content date
        expect(page).to have_content order.code
      end
    end
    within('[class="event-card-container general-events"]') do
      within('div.event-card:nth-child(1)') do
        date = I18n.localize(order2.event_date)
        expect(page).to have_content date
        expect(page).to have_content order2.code
      end
    end
  end

  it "and see details from any pending order" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000, sp_additional_person:500,
                          additional_person:200, sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: 1.day.from_now, estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)
    
    login_as user, scope: :user
    visit root_path
    click_on 'Pedidos'
    click_on 'Mostrar Detalhes'

    expect(page).to have_content 'Nome do Buffet: Vini'
    expect(page).to have_content 'Nome do Evento: Casamento'
    formatted_date = I18n.localize(1.day.from_now.to_date)
    expect(page).to have_content "Data do Evento: #{formatted_date}"
    expect(page).to have_content 'Quantidade de pessoas: 30'
    expect(page).to have_content "Código: #{order.code}"
    expect(page).to have_content 'deve ser realizado no endereço: No próprio Buffet'
    expect(page).to have_content 'Status do pedido: Aguardando avaliação do buffet'
    expect(page).to have_content 'Valor final:'
    expect(page).to have_content 'Prazo final para confirmação e pagamento:'
    expect(page).to have_content 'Acréscimos:'
    expect(page).to have_content 'Descontos:'
    expect(page).not_to have_content 'Você possui mais eventos agendados ou confirmados para essa mesma data.'
  end

  it "and see an alert for orders that has another one for same day" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000, sp_additional_person:500,
                          additional_person:200, sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    event2 = Event.create!(name: 'Formatura', description: 'Serviço de mesa completo para formaturas', min_qtd: 200, max_qtd: 400,
                            duration: 350, menu: 'Canapés', buffet_id: buffet.id)
    price = Price.create!(base_price: 3000, sp_base_price:4000, sp_additional_person:400,
                          additional_person:100, sp_extra_hour:60, extra_hour:50, event_id: event2.id)
    album2 = Album.create!(event_id: event2.id)
    album2.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
    customer2 = Customer.create!(email: 'cliente2@email.com', password: 'password2', name: 'cliente2', cpf: '010.279.200-39')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: 1.day.from_now, estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)
    order2 = Order.create!(buffet_id: buffet.id, event_id: event2.id, event_date: 1.day.from_now, estimated_qtd: 300,
                          event_details: 'Se possível, colocar uma pessoa vestida de Han Solo para recepcionar', address: '', order_status: :waiting,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer2.id, out_doors: false)
    
    login_as user, scope: :user
    visit root_path
    click_on 'Pedidos'
    within('[class="event-card-container pending-events"]') do
      first('.event-card').click_on 'Mostrar Detalhes'
    end

    expect(page).to have_content 'Você possui mais eventos agendados ou confirmados para essa mesma data.'
  end

  it "and do not see form for orders already confirmed or canceled" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000, sp_additional_person:500,
                          additional_person:200, sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2039, 5, 1), estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :confirmed,
                          final_price: "16000", extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)

    login_as user, scope: :user
    visit root_path
    click_on 'Pedidos'
    within('[class="event-card-container general-events"]') do
      first('.event-card').click_on 'Mostrar Detalhes'
    end

    expect(page).not_to have_content "Esses valores são calculados levando em consideração o dia da semana e a quantidade de pessoas."
    expect(page).not_to have_content "Prazo máximo para pagamento"
    expect(page).not_to have_content "Cobrar taxa extra do cliente"
    expect(page).not_to have_content "Conceder desconto ao cliente"
  end

  it "and see the evaluation form" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000, sp_additional_person:500,
                          additional_person:200, sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2039, 5, 1), estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)

    login_as user, scope: :user
    visit root_path
    click_on 'Pedidos'
    within('[class="event-card-container pending-events"]') do
      first('.event-card').click_on 'Mostrar Detalhes'
    end

    expect(page).to have_content "Esses valores são calculados levando em consideração o dia da semana e a quantidade de pessoas."
    expect(page).to have_content "Prazo máximo para pagamento"
    expect(page).to have_content "Acréscimo"
    expect(page).to have_content "Desconto"
    expect(page).to have_content "Cobrar taxa extra do cliente"
    expect(page).to have_content "Conceder desconto ao cliente"
  end

  it "and see the right value for event (weekend or holiday and with aditional people)" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000, sp_additional_person:500,
                          additional_person:200, sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2039, 5, 1), estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)
    final_price = price.sp_base_price + (price.sp_additional_person * (order.estimated_qtd - event.min_qtd))

    login_as user, scope: :user
    visit root_path
    click_on 'Pedidos'
    within('[class="event-card-container pending-events"]') do
      first('.event-card').click_on 'Mostrar Detalhes'
    end

    expect(page).to have_content "O valor do evento está calculado em #{final_price} reais."
  end

  it "and see the right value for event (weekend or holiday and with no aditional people)" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000, sp_additional_person:500,
                          additional_person:200, sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2039, 5, 1), estimated_qtd: 20,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)
    final_price = price.sp_base_price

    login_as user, scope: :user
    visit root_path
    click_on 'Pedidos'
    within('[class="event-card-container pending-events"]') do
      first('.event-card').click_on 'Mostrar Detalhes'
    end

    expect(page).to have_content "O valor do evento está calculado em #{final_price} reais."
  end

  it "and see the right value for event (business day and with aditional people)" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000, sp_additional_person:500,
                          additional_person:200, sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2039, 5, 2), estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)
    final_price = price.base_price + (price.additional_person * (order.estimated_qtd - event.min_qtd))

    login_as user, scope: :user
    visit root_path
    click_on 'Pedidos'
    within('[class="event-card-container pending-events"]') do
      first('.event-card').click_on 'Mostrar Detalhes'
    end

    expect(page).to have_content "O valor do evento está calculado em #{final_price} reais."
  end

  it "and see the right value for event (regular day and with no aditional people)" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000, sp_additional_person:500,
                          additional_person:200, sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2039, 5, 2), estimated_qtd: 20,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)
    final_price = price.base_price

    login_as user, scope: :user
    visit root_path
    click_on 'Pedidos'
    within('[class="event-card-container pending-events"]') do
      first('.event-card').click_on 'Mostrar Detalhes'
    end

    expect(page).to have_content "O valor do evento está calculado em #{final_price} reais."
  end

  it "and tries to evaluate an event without price" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: 1.day.from_now, estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)

    login_as user, scope: :user
    visit root_path
    click_on 'Pedidos'
    within('[class="event-card-container pending-events"]') do
      first('.event-card').click_on 'Mostrar Detalhes'
    end

    expect(current_path).to eq user_index_orders_path
    expect(page).to have_content 'Você precisa cadastrar um preço para esse evento poder ser contratado.'
  end

  it "and can evaluate an event" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000, sp_additional_person:500,
                          additional_person:200, sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2039, 5, 2), estimated_qtd: 40,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)
    final_price = price.base_price

    login_as user, scope: :user
    visit root_path
    click_on 'Pedidos'
    within('[class="event-card-container pending-events"]') do
      first('.event-card').click_on 'Mostrar Detalhes'
    end
    fill_in "Prazo máximo para pagamento", with: 1.day.from_now
    fill_in "Acréscimo", with: 500
    fill_in "Desconto", with: 200
    click_on 'Confirmar Pedido'

    expect(current_path).to eq order_path(order.id)
    date = I18n.localize(1.day.from_now.to_date)
    expect(page).to have_content "Prazo final para confirmação e pagamento: #{date}"
    expect(page).to have_content "Acréscimos: 500"
    expect(page).to have_content "Descontos: 200"
  end

  it "and can evaluate an event do not informing a final payment date (set automatically to 3 days from now)" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000, sp_additional_person:500,
                          additional_person:200, sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2039, 5, 2), estimated_qtd: 40,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)
    final_price = price.base_price

    login_as user, scope: :user
    visit root_path
    click_on 'Pedidos'
    within('[class="event-card-container pending-events"]') do
      first('.event-card').click_on 'Mostrar Detalhes'
    end
    fill_in "Prazo máximo para pagamento", with: ""
    fill_in "Acréscimo", with: 500
    fill_in "Descrição da taxa extra", with: 'Acréscimo pelo vestido de noiva'
    fill_in "Desconto", with: 200
    fill_in "Descrição do desconto", with: 'Desconto pelo cupom do mês da noiva'
    fill_in "Forma de pagamento", with: 'Pix'
    click_on 'Confirmar Pedido'

    expect(current_path).to eq order_path(order.id)
    date = I18n.localize(3.day.from_now.to_date)
    expect(page).to have_content "Prazo final para confirmação e pagamento: #{date}"
    expect(page).to have_content "Acréscimos: 500"
    expect(page).to have_content "Descontos: 200"
    expect(page).to have_content "Descrição do acrésicmo: Acréscimo pelo vestido de noiva"
    expect(page).to have_content "Descrição do desconto: Desconto pelo cupom do mês da noiva"
    expect(page).to have_content "Forma de pagamento: Pix"
  end
end