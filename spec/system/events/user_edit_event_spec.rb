require "rails_helper"

describe 'User edit an event' do
  it 'and are not authenticated' do
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
      register_number: '12456456000145', phone: '53 991814646',
      email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
      district: 'Laranjal', state: 'RS', city: 'Pelotas',
      payment_method: 'Pix, Débito, Crédito, Dinheiro',
      description: 'O melhor serviço de buffet do centro de Pelotas')
    event = Event.create!(name: 'Casamento',
      description: 'Serviço de mesa completo para casamentos',
      min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
      buffet_id: buffet.id)

    visit edit_event_path(event.id)

    expect(current_path).to eq new_user_session_path
  end

  it "and cannot edit other's buffet's events" do
    user1 = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet1 = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
      register_number: '12456456000145', phone: '53 991814646',
      email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
      district: 'Laranjal', state: 'RS', city: 'Pelotas',
      payment_method: 'Pix, Débito, Crédito, Dinheiro',
      description: 'O melhor serviço de buffet do centro de Pelotas')
    user1.update!(buffet_id: buffet1.id)
    event = Event.create!(name: 'Casamento',
      description: 'Serviço de mesa completo para casamentos',
      min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
      buffet_id: buffet1.id)

    user2 = User.create!(email: 'debora@email.com', password: 'password2')
    buffet2 = Buffet.create!(name: 'Dé Licias', corporate_name: 'Débora Doces e tortas', 
      register_number: '12412356000145', phone: '53 991549865',
      email: 'debora@email.com', address: 'Santos Dumont, 695',
      district: 'Centro', state: 'RS', city: 'Piratini',
      payment_method: 'Dinheiro',
      description: 'Doces e tortas para alegrara sua vida')
    user2.update!(buffet_id: buffet2.id)

    login_as user2, scope: :user
    visit edit_event_path(event.id)

    expect(current_path).to eq my_buffet_buffets_path
    expect(page).to have_content 'Você não tem permissão para editar esse evento.'
  end

  it 'and fails' do
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
    click_on 'Editar Evento'
    fill_in 'Cardápio', with: ''
    click_on 'Salvar Evento'

    expect(page).to have_content 'Não foi possível atualizar o Evento.'
    expect(page).to have_content 'Cardápio não pode ficar em branco'
  end

  it 'succesfully, from home page' do
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
    click_on 'Editar Evento'
    fill_in 'Cardápio', with: 'Carnes Nobres'
    click_on 'Salvar Evento'
    click_on 'Mostrar Detalhes'

    expect(page).to have_content 'Cardápio: Carnes Nobres'
    expect(page).not_to have_content 'Cardápio: Frutos do mar'
  end
end