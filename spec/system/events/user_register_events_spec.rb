require "rails_helper"

describe 'User access his own buffet page to create a event' do
  it 'and are not authenticated' do
    visit new_event_path
    
    expect(current_path).to eq new_user_session_path
  end

  it 'and do not see any advise messages for inputs at first' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)

    visit new_event_path

    expect(page).not_to have_content 'Nome não pode ficar em branco'
    expect(page).not_to have_content 'Descrição não pode ficar em branco'
    expect(page).not_to have_content 'Quantidade mínima não pode ficar em branco'
    expect(page).not_to have_content 'Quantidade máxima não pode ficar em branco'
    expect(page).not_to have_content 'Duração não pode ficar em branco'
    expect(page).not_to have_content 'Cardápio não pode ficar em branco'
  end

  it 'with obrigatory fields empty' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)

    login_as user, scope: :user
    visit new_event_path
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    click_on 'Salvar Evento'

    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Quantidade mínima não pode ficar em branco'
    expect(page).to have_content 'Quantidade máxima não pode ficar em branco'
    expect(page).to have_content 'Duração não pode ficar em branco'
    expect(page).to have_content 'Cardápio não pode ficar em branco'
  end

  it 'and the advise message disapear for a filled input' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)

    login_as user, scope: :user
    visit new_event_path
    fill_in 'Nome', with: 'Casamento'
    fill_in 'Descrição', with: ''
    click_on 'Salvar Evento'

    expect(page).not_to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Quantidade mínima não pode ficar em branco'
    expect(page).to have_content 'Quantidade máxima não pode ficar em branco'
    expect(page).to have_content 'Duração não pode ficar em branco'
    expect(page).to have_content 'Cardápio não pode ficar em branco'
  end

  it 'succesfully, directly redirect after login' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)

    login_as user, scope: :user
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Adicionar Evento'
    fill_in 'Nome', with: 'Casamento'
    fill_in 'Descrição', with: 'Serviço para festas de casamento'
    fill_in 'Quantidade mínima', with: '50'
    fill_in 'Quantidade máxima', with: '500'
    fill_in 'Duração', with: '240'
    fill_in 'Cardápio', with: 'Frutos do mar'
    click_on 'Salvar Evento'

    expect(current_path).to eq my_buffet_buffets_path
    expect(page).to have_content 'Casamento'
    expect(page).to have_content 'Serviço para festas de casamento'
    expect(page).to have_content '500'
    expect(page).to have_content 'Mostrar Detalhes'
  end

  it 'and see more than one' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event1 = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    event2 = Event.create!(name: 'Evento Corporativo', description: 'Buffet com estilo mais profissional para eventos de empresa', min_qtd: 40, max_qtd: 100,
                          duration: 360, menu: 'Canapés', buffet_id: buffet.id)
    
    login_as user, scope: :user
    visit my_buffet_buffets_path

    expect(page).to have_content 'Casamento'
    expect(page).to have_content 'Serviço de mesa completo para casamentos'
    expect(page).to have_content '40'
    expect(page).to have_content 'Mostrar Detalhes'
    expect(page).to have_content 'Evento Corporativo'
    expect(page).to have_content 'Buffet com estilo mais profissional para eventos de empresa'
    expect(page).to have_content '100'
  end

  it "and do not see others owner's events" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet1 = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet1.id)
    user2 = User.create!(email: 'debora@email.com', password: 'password')
    buffet2 = Buffet.create!(name: 'Dedi', corporate_name: 'Dedi alimentos', 
                          register_number: '12456454000145', phone: '53 991815454', email: 'dedi@gourmet.com',
                          address: 'Rua Andrade Neves, 600', district: 'Centro', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Dinheiro', description: 'Tortas e bolos feitos com amor')
    user2.update!(buffet_id: buffet2.id)
    event1 = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet1.id)
    event2 = Event.create!(name: 'Evento Corporativo', description: 'Buffet com estilo mais profissional para eventos de empresa', min_qtd: 40, max_qtd: 100,
                          duration: 360, menu: 'Canapés', buffet_id: buffet2.id)
    
    login_as user, scope: :user
    visit my_buffet_buffets_path

    expect(page).to have_content 'Casamento'
    expect(page).to have_content 'Serviço de mesa completo para casamentos'
    expect(page).to have_content '40'
    expect(page).to have_content 'Valor ainda não informado'
    expect(page).to have_content 'Mostrar Detalhes'
    expect(page).not_to have_content 'Evento Corporativo'
    expect(page).not_to have_content 'Buffet com estilo mais profissional para eventos de empresa'
    expect(page).not_to have_content '100'
  end
end