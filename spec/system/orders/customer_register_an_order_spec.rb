require "rails_helper"

describe "Customer create an order" do
  it "and see a 'Realizar Pedido' button" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
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

    customer = Customer.create!(email: 'cliente@email.com', password: 'password',
      name: 'cliente', cpf: '479.111.310-15')

    login_as customer, scope: :customer
    visit root_path
    click_on 'Lista de Buffets'
    click_on 'Vini'
    click_on 'Mostrar Detalhes'

    expect(page).to have_button 'Realizar Pedido'
  end

  it "and fail because of blank fields" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
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

    customer = Customer.create!(email: 'cliente@email.com', password: 'password',
      name: 'cliente', cpf: '479.111.310-15')

    login_as customer, scope: :customer
    visit root_path
    click_on 'Lista de Buffets'
    click_on 'Vini'
    click_on 'Mostrar Detalhes'
    click_on 'Realizar Pedido'
    fill_in 'Quantidade estimada de pessoas', with: ''
    fill_in 'Detalhes do evento', with: ''
    click_on 'Salvar Pedido'

    expect(page).to have_content 'Não foi possível registrar o pedido.'
    expect(page).to have_content 'Data do evento não pode ficar em branco'
    expect(page).to have_content 'Quantidade estimada de pessoas não pode ficar em branco'
    expect(page).to have_content 'Detalhes do evento não pode ficar em branco'
  end

  it "with success, from home page" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
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

    customer = Customer.create!(email: 'cliente@email.com', password: 'password',
      name: 'cliente', cpf: '479.111.310-15')

    login_as customer, scope: :customer
    visit root_path
    click_on 'Lista de Buffets'
    click_on 'Vini'
    click_on 'Mostrar Detalhes'
    click_on 'Realizar Pedido'
    fill_in 'Data do evento', with: 1.day.from_now
    fill_in 'Quantidade estimada de pessoas', with: '30'
    fill_in 'Detalhes do evento', with: 'Formatura do meu filho em Ciência da Computação, gostaria de ter uma decoração da cultura Geek.'
    click_on 'Salvar Pedido'

    expect(page).to have_content 'Pedido registrado com sucesso! Aguarde a análise do Buffet.'
    expect(current_path).to eq event_path(event.id)
  end
end