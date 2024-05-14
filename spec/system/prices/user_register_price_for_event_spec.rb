require "rails_helper"

describe 'User register a price for an event' do
  it 'and are not authenticated' do
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

    visit new_event_price_path(event_id: 1)

    expect(current_path).to eq new_user_session_path
  end

  it 'and do not see any advise messages for inputs at first' do
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

    login_as user, scope: :user
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Mostrar Detalhes'
    click_on 'Adicionar Preço'

    expect(page).not_to have_content 'Preço Base não pode ficar em branco'
    expect(page).not_to have_content 'Adicional por Pessoa não pode ficar em branco'
    expect(page).not_to have_content 'Adicional por Hora Extra não pode ficar em branco'
    expect(page).not_to have_content 'Preço Base Especial não pode ficar em branco'
    expect(page).not_to have_content 'Adicional por Pessoa Especial não pode ficar em branco'
    expect(page).not_to have_content 'Adicional por Hora Extra Especial não pode ficar em branco'
  end

  it 'with obrigatory fields empty' do
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

    login_as user, scope: :user
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Mostrar Detalhes'
    click_on 'Adicionar Preço'
    fill_in 'Preço Base', with: ''
    fill_in 'Adicional por Pessoa', with: ''
    click_on 'Salvar Preço'

    expect(page).to have_content 'Preço Base não pode ficar em branco'
    expect(page).to have_content 'Adicional por Pessoa não pode ficar em branco'
    expect(page).to have_content 'Adicional por Hora Extra não pode ficar em branco'
    expect(page).to have_content 'Preço Base Especial não pode ficar em branco'
    expect(page).to have_content 'Adicional por Pessoa Especial não pode ficar em branco'
    expect(page).to have_content 'Adicional por Hora Extra Especial não pode ficar em branco'
  end

  it 'and the advise message disapear for a filled input' do
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

    login_as user, scope: :user
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Mostrar Detalhes'
    click_on 'Adicionar Preço'
    fill_in 'Preço Base', with: '5000'
    fill_in 'Adicional por Pessoa', with: ''
    click_on 'Salvar Preço'

    expect(page).not_to have_content 'Preço Base não pode ficar em branco'
    expect(page).to have_content 'Adicional por Pessoa não pode ficar em branco'
    expect(page).to have_content 'Adicional por Hora Extra não pode ficar em branco'
    expect(page).to have_content 'Preço Base Especial não pode ficar em branco'
    expect(page).to have_content 'Adicional por Pessoa Especial não pode ficar em branco'
    expect(page).to have_content 'Adicional por Hora Extra Especial não pode ficar em branco'
  end

  it 'succesfully, directly redirect after login' do
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

    login_as user, scope: :user
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Mostrar Detalhes'
    click_on 'Adicionar Preço'
    fill_in 'Preço Base', with: '5000'
    fill_in 'Adicional por Pessoa', with: '200'
    fill_in 'Adicional por Hora Extra', with: '50'
    fill_in 'Preço Base Especial', with: '6000'
    fill_in 'Adicional por Pessoa Especial', with: '250'
    fill_in 'Adicional por Hora Extra Especial', with: '50'
    click_on 'Salvar Preço'

    expect(current_path).to eq event_path(event.id)
    expect(page).to have_content 'Preço cadastrado com sucesso.'
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

  it 'and cannot register another for an event that already has prices' do
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
    
    login_as user, scope: :user
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Mostrar Detalhes'

    expect(page).to have_button 'Adicionar Preço'
    expect(page).not_to have_button 'Editar Preço'
  end

  it "and cannot register price for another's events" do
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
    user2 = User.create!(email: 'debora@email.com', password: 'password')
    buffet2 = Buffet.create!(name: 'Dedi', corporate_name: 'Dedi alimentos', 
      register_number: '12456454000145', phone: '53 991815454',
      email: 'dedi@gourmet.com', address: 'Rua Andrade Neves, 600',
      district: 'Centro', state: 'RS', city: 'Pelotas',
      payment_method: 'Pix, Dinheiro',
      description: 'Tortas e bolos feitos com amor')
    user2.update!(buffet_id: buffet2.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000,
      sp_additional_person:500, additional_person:200,
      sp_extra_hour:30, extra_hour:20, event_id: event.id)

    login_as user2, scope: :user
    visit event_path(event.id)

    expect(page).not_to have_button 'Editar Preço'
    expect(page).not_to have_button 'Adicionar Preço'
  end

  it "and cannot register price for another's events even forced" do
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
    user2 = User.create!(email: 'debora@email.com', password: 'password')
    buffet2 = Buffet.create!(name: 'Dedi', corporate_name: 'Dedi alimentos', 
      register_number: '12456454000145', phone: '53 991815454',
      email: 'dedi@gourmet.com', address: 'Rua Andrade Neves, 600',
      district: 'Centro', state: 'RS', city: 'Pelotas',
      payment_method: 'Pix, Dinheiro',
      description: 'Tortas e bolos feitos com amor')
    user2.update!(buffet_id: buffet2.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000,
      sp_additional_person:500, additional_person:200,
      sp_extra_hour:30, extra_hour:20, event_id: event.id)

    login_as user2, scope: :user
    visit new_event_price_path(event.id)
                            
    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para criar preços para eventos de outras contas.'
  end
end