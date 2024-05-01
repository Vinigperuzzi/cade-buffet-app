require "rails_helper"

describe "Customer see order's list" do
  it "and only see self orders" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    event2 = Event.create!(name: 'Formatura', description: 'Evento para solenidades', min_qtd: 60, max_qtd: 80,
                            duration: 320, menu: 'Canapés', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000, sp_additional_person:500,
                          additional_person:200, sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')

    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente1', cpf: '479.111.310-15')
    customer2 = Customer.create!(email: 'customer@email.com', password: 'password2', name: 'cliente2', cpf: '283.101.870-68')

    order1 = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: 1.day.from_now, estimated_qtd: 200,
                        event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                        final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)
    order1.valid?
    order2 = Order.create!(buffet_id: buffet.id, event_id: event2.id, event_date: 1.day.from_now, estimated_qtd: 200,
                        event_details: 'Quero temática Geek para a formatura em Ciência da Computação', address: '', order_status: :waiting,
                        final_price: nil, extra_tax: nil, discount: nil, customer_id: customer2.id, out_doors: false)
    order2.valid?

    login_as customer, scope: :customer
    visit root_path
    click_on 'Meus Pedidos'
    
    expect(page).to have_content order1.code
    expect(page).not_to have_content order2.code
  end
  
  it "and see the pending ones first" do
    pending 'Primeiro é necessário diferenciar entre pendente e avaliado'
    expect(true).to eq false
  end

  it "and see the pending in ordered by date (my own feature)" do
    pending 'Primeiro é necessário diferenciar entre pendente e avaliado'
    expect(true).to eq false
  end

  it "and see the general ones last" do
    pending 'Primeiro é necessário diferenciar entre pendente e avaliado'
    expect(true).to eq false
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
    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: 1.day.from_now, estimated_qtd: 200,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)
    
    login_as customer, scope: :customer
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'Mostrar Detalhes'

    expect(page).to have_content 'Nome do Buffet: Vini'
    expect(page).to have_content 'Nome do Evento: Casamento'
    formatted_date = I18n.localize(1.day.from_now.to_date)
    expect(page).to have_content "Data do Evento: #{formatted_date}"
    expect(page).to have_content 'Quantidade de pessoas: 200'
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
    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: 1.day.from_now, estimated_qtd: 200,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: nil, extra_tax: nil, discount: nil, customer_id: customer.id, out_doors: false)
    order2 = Order.create!(buffet_id: buffet.id, event_id: event2.id, event_date: 1.day.from_now, estimated_qtd: 400,
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

  it "and can confirm an evaluated event" do
    pending 'Primeiro é necessário diferenciar entre pendente e avaliado'
    expect(true).to eq false
  end
end