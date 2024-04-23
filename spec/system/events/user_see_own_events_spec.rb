require "rails_helper"

describe 'User sees details of an event' do
  it 'and are not authenticated' do
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    visit event_path(event.id)

    expect(current_path).to eq new_user_session_path
  end

  it 'and are authenticated' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)

    login_as(user)
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Mostrar Detalhes'
    expect(current_path).to eq event_path(buffet.id)
    expect(page).to have_content 'Nome: Casamento'
    expect(page).to have_content 'Descrição: Serviço de mesa completo para casamentos'
    expect(page).to have_content 'Quantidade mínima de pessoas: 20'
    expect(page).to have_content 'Quantidade máxima de pessoas: 40'
    expect(page).to have_content 'Duração: 250'
    expect(page).to have_content 'Cardápio: Frutos do Mar'
    expect(page).to have_content 'Bebidas Alcoólicas: Não disponíveis'
    expect(page).to have_content 'Decoração: Não disponível'
    expect(page).to have_content 'Serviço de Estacionamento: Não disponível'
    expect(page).to have_content 'Exclusivo no local: Evento pode ser feito em qualquer outro local adequado'
  end

  it 'and it own the event' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)

    login_as(user)
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Mostrar Detalhes'

    expect(page).to have_content 'Editar Evento'
  end

  it 'and it do not own the event' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    user2 = User.create!(email: 'debora@email.com', password: 'password')
    buffet2 = Buffet.create!(name: 'Dedi', corporate_name: 'Dedi alimentos', 
                          register_number: '12456454000145', phone: '53 991815454', email: 'dedi@gourmet.com',
                          address: 'Rua Andrade Neves, 600', district: 'Centro', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Dinheiro', description: 'Tortas e bolos feitos com amor')
    user2.update!(buffet_id: buffet2.id)

    login_as(user2)
    visit event_path(event.id)

    expect(page).not_to have_content 'Editar Evento'
  end
end