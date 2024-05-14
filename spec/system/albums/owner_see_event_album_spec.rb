require "rails_helper"

describe "owner see an album from a event" do
  it 'see all images from own events' do
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

    login_as user, scope: :user
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Mostrar Detalhes'
    expect(page).to have_selector('img[src*="festa_casamento.jpg"]')
  end

  it "and do not have the option to add images from other's events" do
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
    user2 = User.create!(email: 'debora@email.com', password: 'password2')
    buffet2 = Buffet.create!(name: 'Dedi', corporate_name: 'Débora Gourmet alimentos', 
      register_number: '12443456000145', phone: '53 991535353',
      email: 'dedi@delicias.com', address: 'Andrade Neves, 15',
      district: 'Centro', state: 'RS', city: 'Piratini',
      payment_method: 'Pix, Dinheiro',
      description: 'Qualidade e excelência para melhor servi-lo')
    user2.update!(buffet_id: buffet2.id)
    event2 = Event.create!(name: 'Formatura',
      description: 'Solenidade elegante para recepções de colação de grau',
      min_qtd: 50, max_qtd: 90, duration: 250, menu: 'Canapés',
      buffet_id: buffet2.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000,
      sp_additional_person:500, additional_person:200,
      sp_extra_hour:30, extra_hour:20, event_id: event2.id)
    album2 = Album.create!(event_id: event2.id)
    album2.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')

    login_as user, scope: :user

    visit event_path(event2)
    expect(page).not_to have_content 'Adicionar Imagens ao Álbum'
    expect(page).not_to have_content 'Editar Álbum'
  end

  it "and cannot add images even forcing via route from other's events" do
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
    user2 = User.create!(email: 'debora@email.com', password: 'password2')
    buffet2 = Buffet.create!(name: 'Dedi', corporate_name: 'Débora Gourmet alimentos', 
      register_number: '12443456000145', phone: '53 991535353',
      email: 'dedi@delicias.com', address: 'Andrade Neves, 15',
      district: 'Centro', state: 'RS', city: 'Piratini',
      payment_method: 'Pix, Dinheiro',
      description: 'Qualidade e excelência para melhor servi-lo')
    user2.update!(buffet_id: buffet2.id)
    event2 = Event.create!(name: 'Formatura',
      description: 'Solenidade elegante para recepções de colação de grau',
      min_qtd: 50, max_qtd: 90, duration: 250, menu: 'Canapés',
      buffet_id: buffet2.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000,
      sp_additional_person:500, additional_person:200,
      sp_extra_hour:30, extra_hour:20, event_id: event2.id)
    album2 = Album.create!(event_id: event2.id)
    album2.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')

    login_as user, scope: :user

    visit new_event_album_path(event_id: event2.id)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para adicionar fotos em outras contas.'
  end

  it "and cannot add images even forcing via route from other's events" do
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
    user2 = User.create!(email: 'debora@email.com', password: 'password2')
    buffet2 = Buffet.create!(name: 'Dedi', corporate_name: 'Débora Gourmet alimentos', 
      register_number: '12443456000145', phone: '53 991535353',
      email: 'dedi@delicias.com', address: 'Andrade Neves, 15',
      district: 'Centro', state: 'RS', city: 'Piratini',
      payment_method: 'Pix, Dinheiro',
      description: 'Qualidade e excelência para melhor servi-lo')
    user2.update!(buffet_id: buffet2.id)
    event2 = Event.create!(name: 'Formatura',
      description: 'Solenidade elegante para recepções de colação de grau',
      min_qtd: 50, max_qtd: 90, duration: 250, menu: 'Canapés',
      buffet_id: buffet2.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000,
      sp_additional_person:500, additional_person:200,
      sp_extra_hour:30, extra_hour:20, event_id: event2.id)
    album2 = Album.create!(event_id: event2.id)
    album2.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')

    login_as user, scope: :user

    visit edit_event_album_path(event_id: event2.id, id: album2.id)

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para editar preços para eventos de outras contas.'
  end
end