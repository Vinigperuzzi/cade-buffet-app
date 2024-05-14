require "rails_helper"

describe "customer see an album from a event" do
  it 'see all images' do
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
      sp_additional_person:500, additional_person:200,
      sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')

    customer = Customer.create!(email: 'cliente@email.com', password: 'password',
      name: 'cliente', cpf: '479.111.310-15')

    login_as customer, scope: :customer
    visit root_path
    click_on 'Lista de Buffets'
    click_on 'Vini'
    click_on 'Mostrar Detalhes'
    expect(page).to have_selector('img[src*="festa_casamento.jpg"]')
  end

  it 'and do not have the option to add nor edit images' do
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
      min_qtd: 20, max_qtd: 40, duration: 250,
      menu: 'Frutos do Mar', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000,
      sp_additional_person:500, additional_person:200,
      sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    customer = Customer.create!(email: 'cliente@email.com', password: 'password',
      name: 'cliente', cpf: '479.111.310-15')

    login_as customer, scope: :customer
    visit root_path
    click_on 'Lista de Buffets'
    click_on 'Vini'
    click_on 'Mostrar Detalhes'
    expect(page).not_to have_content 'Adicionar Imagens ao Álbum'
    expect(page).not_to have_content 'Editar Álbum'
  end

  it 'and cannot add images even forcing via route' do
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
      sp_additional_person:500, additional_person:200,
      sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    customer = Customer.create!(email: 'cliente@email.com', password: 'password',
      name: 'cliente', cpf: '479.111.310-15')

    login_as customer, scope: :customer
    visit new_event_album_path(event_id: event.id)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it 'and cannot edit images even forcing via route' do
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
      sp_additional_person:500, additional_person:200,
      sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    customer = Customer.create!(email: 'cliente@email.com', password: 'password',
      name: 'cliente', cpf: '479.111.310-15')

    login_as customer, scope: :customer
    visit edit_event_album_path(event_id: event.id, id: album.id)

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end
end