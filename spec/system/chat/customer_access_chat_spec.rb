require "rails_helper"

describe 'Customer access chat' do
  it "and can see chat button" do
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
    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :confirmed,
                          final_price: 11000, extra_tax: 1000, discount: 500, customer_id: customer.id, out_doors: false)

    login_as customer, scope: :customer
    visit order_path(order.id)
    
    expect(page).to have_link "Conversar com o buffet sobre esse pedido"
  end

  it "and access chat page for only it's own order's chat" do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
    customer2 = Customer.create!(email: 'cliente2@email.com', password: 'password2', name: 'cliente2', cpf: '325.066.805-27')
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

    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: 11000, extra_tax: 1000, discount: 500, customer_id: customer.id, out_doors: false)

    order2 = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
                          event_details: 'A festa deve ser realizada duranto do dia caso não esteja chovendo', address: '', order_status: :waiting,
                          final_price: 11000, extra_tax: 0, discount: 0, customer_id: customer2.id, out_doors: false)

    login_as customer, scope: :customer
    visit order_messages_path(order2.id)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não permissão para acessar esse chat.'
  end

  it "and can see order's code, buffet's, event's and customer's name and event's date" do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
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

    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: 11000, extra_tax: 1000, discount: 500, customer_id: customer.id, out_doors: false)

    login_as customer, scope: :customer
    visit order_path(order.id)
    click_on 'Conversar com o buffet sobre esse pedido'

    expect(current_path).to eq order_messages_path(order.id)
    expect(page).to have_content 'Casamento do buffet Vini pedido por cliente'
    expect(page).to have_content "Código do pedido: #{order.code}"
  end

  it "and can send messages and see own messages and sent time" do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
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

    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: 11000, extra_tax: 1000, discount: 500, customer_id: customer.id, out_doors: false)

    login_as customer, scope: :customer
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'Mostrar Detalhes'
    click_on 'Conversar com o buffet sobre esse pedido'
    fill_in "message_text", with: 'Tudo bem, e com você?'
    click_on 'Enviar mensagem'

    expect(current_path).to eq order_messages_path(order.id)
    expect(page).to have_content "Tudo bem, e com você?"
    message = Message.last
    expect(page).to have_content message.created_at.to_datetime.in_time_zone('Brasilia').strftime("%d/%m/%Y %H:%M:%S")
  end

  it "and can see messages send by customer and answer" do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
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

    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: 11000, extra_tax: 1000, discount: 500, customer_id: customer.id, out_doors: false)
    message = Message.create!(order_id: order.id, sender: :user, customer_read: false, user_read: false, message_text: 'Olá, tudo bem?')

    login_as customer, scope: :customer
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'Mostrar Detalhes'
    click_on 'Conversar com o buffet sobre esse pedido'
    fill_in "message_text", with: 'Tudo bem, e com você?'
    click_on 'Enviar mensagem'

    expect(current_path).to eq order_messages_path(order.id)
    expect(page).to have_content "Olá, tudo bem?"
    expect(page).to have_content message.created_at.to_datetime.in_time_zone('Brasilia').strftime("%d/%m/%Y %H:%M:%S")
    message2 = Message.last
    expect(page).to have_content "Tudo bem, e com você?"
    expect(page).to have_content message2.created_at.to_datetime.in_time_zone('Brasilia').strftime("%d/%m/%Y %H:%M:%S")
  end

  it "and can see messages marked as not visualized" do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
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

    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: 11000, extra_tax: 1000, discount: 500, customer_id: customer.id, out_doors: false)
    message = Message.create!(order_id: order.id, sender: :customer, customer_read: true, user_read: false, message_text: 'Olá, tudo bem?')

    login_as customer, scope: :customer
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'Mostrar Detalhes'
    click_on 'Conversar com o buffet sobre esse pedido'

    expect(page).to have_content "Olá, tudo bem?"
    expect(page).to have_content message.created_at.to_datetime.in_time_zone('Brasilia').strftime("%d/%m/%Y %H:%M:%S")
    expect(page).to have_content "🗳️"
  end

  it "and can see messages marked as visualized" do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
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

    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: 11000, extra_tax: 1000, discount: 500, customer_id: customer.id, out_doors: false)
    message = Message.create!(order_id: order.id, sender: :customer, customer_read: true, user_read: true, message_text: 'Olá, tudo bem?')

    login_as customer, scope: :customer
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'Mostrar Detalhes'
    click_on 'Conversar com o buffet sobre esse pedido'

    expect(page).to have_content "Olá, tudo bem?"
    expect(page).to have_content message.created_at.to_datetime.in_time_zone('Brasilia').strftime("%d/%m/%Y %H:%M:%S")
    expect(page).to have_content "✔️"
  end

  it "and can edit a message" do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
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

    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: 11000, extra_tax: 1000, discount: 500, customer_id: customer.id, out_doors: false)
    message = Message.create!(order_id: order.id, sender: :customer, customer_read: true, user_read: true, message_text: 'Olá, tudo bem?')

    login_as customer, scope: :customer
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'Mostrar Detalhes'
    click_on 'Conversar com o buffet sobre esse pedido'
    click_on '✎'
    fill_in "message_text", with: 'Boa tarde, tudo bem?'
    click_on 'Enviar mensagem'

    expect(current_path).to eq order_messages_path(order.id)
    expect(page).to have_content "Boa tarde, tudo bem?"
  end

  it "and cannot edit a message from other's customer's order" do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
    customer2 = Customer.create!(email: 'cliente2@email.com', password: 'password2', name: 'cliente2', cpf: '325.066.805-27')
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

    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: 11000, extra_tax: 1000, discount: 500, customer_id: customer.id, out_doors: false)
    message = Message.create!(order_id: order.id, sender: :customer, customer_read: true, user_read: true, message_text: 'Olá, tudo bem?')

    login_as customer2, scope: :customer
    visit edit_order_message_path(order_id: order.id, id: message.id)
    
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não permissão para acessar esse chat.'
  end

  it "and cannot edit a owner's message" do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
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

    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: 11000, extra_tax: 1000, discount: 500, customer_id: customer.id, out_doors: false)
    message = Message.create!(order_id: order.id, sender: :user, customer_read: true, user_read: true, message_text: 'Olá, tudo bem?')

    login_as customer, scope: :customer
    visit order_message_path(order_id: order.id, id: message.id)
    
    expect(page).not_to have_content "✎"
  end

  it "and cannot edit a owner's message forcing url" do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
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

    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: 11000, extra_tax: 1000, discount: 500, customer_id: customer.id, out_doors: false)
    message = Message.create!(order_id: order.id, sender: :user, customer_read: true, user_read: true, message_text: 'Olá, tudo bem?')

    login_as customer, scope: :customer
    visit edit_order_message_path(order_id: order.id, id: message.id)
    
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não permissão para editar essa mensagem.'
  end

  it "and can get back to order's page" do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
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

    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :waiting,
                          final_price: 11000, extra_tax: 1000, discount: 500, customer_id: customer.id, out_doors: false)

    login_as customer, scope: :customer
    visit root_path
    click_on 'Meus Pedidos'
    click_on 'Mostrar Detalhes'
    click_on 'Conversar com o buffet sobre esse pedido'
    fill_in "message_text", with: 'Tudo bem, e com você?'
    click_on 'Enviar mensagem'
    click_on 'Voltar ao pedido'

    expect(current_path).to eq order_path(order.id)
  end
end