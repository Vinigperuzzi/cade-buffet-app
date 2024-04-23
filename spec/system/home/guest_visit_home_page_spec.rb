require "rails_helper"

describe 'Guest visit home page' do
  it 'and sees "Cadê Buffet" Title and nav buttons' do
    visit root_path

    expect(page).to have_content 'Cadê Buffet'
    expect(page).to have_content 'Lista de Buffets'
    expect(page).not_to have_content 'Meu Buffet'
  end

  it 'and can search for buffet' do
    visit root_path

    expect(page).to have_content 'Buscar Buffet'
    expect(page).to have_button 'Buscar'
  end

  it 'and search for a buffet by name' do
    user1 = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet1 = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user1.update!(buffet_id: buffet1.id)

    user2 = User.create!(email: 'debora@email.com', password: 'password2')
    buffet2 = Buffet.create!(name: 'Dé Licias', corporate_name: 'Débora Doces e tortas', 
                          register_number: '12412356000145', phone: '53 991549865', email: 'debora@email.com',
                          address: 'Santos Dumont, 695', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Dinheiro', description: 'Doces e tortas para alegrara sua vida')
    
    user2.update!(buffet_id: buffet2.id)

    user3 = User.create!(email: 'henrique@email.com', password: 'password3')
    buffet3 = Buffet.create!(name: 'Potinho de Ração', corporate_name: 'Babi festas e eventos', 
                          register_number: '98746456000145', phone: '53 991535353', email: 'babi@miau.com',
                          address: 'Rua dos gatos, 700', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro,', description: 'Serviço de Buffet saudável para pets')
    
    user3.update!(buffet_id: buffet3.id)

    event1 = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet1.id)
    event2 = Event.create!(name: 'Formatura', description: 'Serviço de mesa completo para formaturas', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet1.id)
    event3 = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet2.id)
    event4 = Event.create!(name: 'Aniversário', description: 'Serviço de mesa completo para aniversários', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet2.id)
    event5 = Event.create!(name: 'Chá Revelação', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet3.id)
    event6 = Event.create!(name: 'Eventos Corporativos', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet3.id)

    visit root_path
    fill_in 'Buscar Buffet', with: 'Vini'
    click_on 'Buscar'

    expect(page).to have_content 'Vini'
    expect(page).not_to have_content 'Dé Licias'
    expect(page).not_to have_content 'Potinho de Ração'
  end

  it 'and search for a buffet by city' do
    user1 = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet1 = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user1.update!(buffet_id: buffet1.id)

    user2 = User.create!(email: 'debora@email.com', password: 'password2')
    buffet2 = Buffet.create!(name: 'Dé Licias', corporate_name: 'Débora Doces e tortas', 
                          register_number: '12412356000145', phone: '53 991549865', email: 'debora@email.com',
                          address: 'Santos Dumont, 695', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Dinheiro', description: 'Doces e tortas para alegrara sua vida')
    
    user2.update!(buffet_id: buffet2.id)

    user3 = User.create!(email: 'henrique@email.com', password: 'password3')
    buffet3 = Buffet.create!(name: 'Potinho de Ração', corporate_name: 'Babi festas e eventos', 
                          register_number: '98746456000145', phone: '53 991535353', email: 'babi@miau.com',
                          address: 'Rua dos gatos, 700', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro,', description: 'Serviço de Buffet saudável para pets')
    
    user3.update!(buffet_id: buffet3.id)

    event1 = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet1.id)
    event2 = Event.create!(name: 'Formatura', description: 'Serviço de mesa completo para formaturas', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet1.id)
    event3 = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet2.id)
    event4 = Event.create!(name: 'Aniversário', description: 'Serviço de mesa completo para aniversários', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet2.id)
    event5 = Event.create!(name: 'Chá Revelação', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet3.id)
    event6 = Event.create!(name: 'Eventos Corporativos', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet3.id)

    visit root_path
    fill_in 'Buscar Buffet', with: 'Piratini'
    click_on 'Buscar'

    expect(page).not_to have_content 'Vini'
    expect(page).to have_content 'Dé Licias'
    expect(page).to have_content 'Potinho de Ração'
  end

  it 'and search for a buffet by event name' do
    user1 = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet1 = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user1.update!(buffet_id: buffet1.id)

    user2 = User.create!(email: 'debora@email.com', password: 'password2')
    buffet2 = Buffet.create!(name: 'Dé Licias', corporate_name: 'Débora Doces e tortas', 
                          register_number: '12412356000145', phone: '53 991549865', email: 'debora@email.com',
                          address: 'Santos Dumont, 695', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Dinheiro', description: 'Doces e tortas para alegrara sua vida')
    
    user2.update!(buffet_id: buffet2.id)

    user3 = User.create!(email: 'henrique@email.com', password: 'password3')
    buffet3 = Buffet.create!(name: 'Potinho de Ração', corporate_name: 'Babi festas e eventos', 
                          register_number: '98746456000145', phone: '53 991535353', email: 'babi@miau.com',
                          address: 'Rua dos gatos, 700', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro,', description: 'Serviço de Buffet saudável para pets')
    
    user3.update!(buffet_id: buffet3.id)

    event1 = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet1.id)
    event2 = Event.create!(name: 'Formatura', description: 'Serviço de mesa completo para formaturas', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet1.id)
    event3 = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet2.id)
    event4 = Event.create!(name: 'Aniversário', description: 'Serviço de mesa completo para aniversários', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet2.id)
    event5 = Event.create!(name: 'Chá Revelação', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet3.id)
    event6 = Event.create!(name: 'Eventos Corporativos', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet3.id)

    visit root_path
    fill_in 'Buscar Buffet', with: 'Casamento'
    click_on 'Buscar'

    expect(page).to have_content 'Vini'
    expect(page).to have_content 'Dé Licias'
    expect(page).not_to have_content 'Potinho de Ração'
  end

  it 'and search for a buffet by fragment name' do
    user1 = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet1 = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user1.update!(buffet_id: buffet1.id)

    user2 = User.create!(email: 'debora@email.com', password: 'password2')
    buffet2 = Buffet.create!(name: 'Dé Licias', corporate_name: 'Débora Doces e tortas', 
                          register_number: '12412356000145', phone: '53 991549865', email: 'debora@email.com',
                          address: 'Santos Dumont, 695', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Dinheiro', description: 'Doces e tortas para alegrara sua vida')
    
    user2.update!(buffet_id: buffet2.id)

    user3 = User.create!(email: 'henrique@email.com', password: 'password3')
    buffet3 = Buffet.create!(name: 'Potinho de Ração', corporate_name: 'Babi festas e eventos', 
                          register_number: '98746456000145', phone: '53 991535353', email: 'babi@miau.com',
                          address: 'Rua dos gatos, 700', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro,', description: 'Serviço de Buffet saudável para pets')
    
    user3.update!(buffet_id: buffet3.id)

    event1 = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet1.id)
    event2 = Event.create!(name: 'Formatura', description: 'Serviço de mesa completo para formaturas', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet1.id)
    event3 = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet2.id)
    event4 = Event.create!(name: 'Aniversário', description: 'Serviço de mesa completo para aniversários', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet2.id)
    event5 = Event.create!(name: 'Chá Revelação', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet3.id)
    event6 = Event.create!(name: 'Eventos Corporativos', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet3.id)

    visit root_path
    fill_in 'Buscar Buffet', with: 'vi'
    click_on 'Buscar'

    expect(page).to have_content 'Vini'
    expect(page).not_to have_content 'Dé Licias'
    expect(page).not_to have_content 'Potinho de Ração'
  end

  it 'and search for a buffet by city' do
    user1 = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet1 = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user1.update!(buffet_id: buffet1.id)

    user2 = User.create!(email: 'debora@email.com', password: 'password2')
    buffet2 = Buffet.create!(name: 'Dé Licias', corporate_name: 'Débora Doces e tortas', 
                          register_number: '12412356000145', phone: '53 991549865', email: 'debora@email.com',
                          address: 'Santos Dumont, 695', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Dinheiro', description: 'Doces e tortas para alegrara sua vida')
    
    user2.update!(buffet_id: buffet2.id)

    user3 = User.create!(email: 'henrique@email.com', password: 'password3')
    buffet3 = Buffet.create!(name: 'Potinho de Ração', corporate_name: 'Babi festas e eventos', 
                          register_number: '98746456000145', phone: '53 991535353', email: 'babi@miau.com',
                          address: 'Rua dos gatos, 700', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro,', description: 'Serviço de Buffet saudável para pets')
    
    user3.update!(buffet_id: buffet3.id)

    event1 = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet1.id)
    event2 = Event.create!(name: 'Formatura', description: 'Serviço de mesa completo para formaturas', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet1.id)
    event3 = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet2.id)
    event4 = Event.create!(name: 'Aniversário', description: 'Serviço de mesa completo para aniversários', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet2.id)
    event5 = Event.create!(name: 'Chá Revelação', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet3.id)
    event6 = Event.create!(name: 'Eventos Corporativos', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet3.id)

    visit root_path
    fill_in 'Buscar Buffet', with: 'tini'
    click_on 'Buscar'

    expect(page).not_to have_content 'Vini'
    expect(page).to have_content 'Dé Licias'
    expect(page).to have_content 'Potinho de Ração'
  end

  it 'and search for a buffet by event name' do
    user1 = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet1 = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user1.update!(buffet_id: buffet1.id)

    user2 = User.create!(email: 'debora@email.com', password: 'password2')
    buffet2 = Buffet.create!(name: 'Dé Licias', corporate_name: 'Débora Doces e tortas', 
                          register_number: '12412356000145', phone: '53 991549865', email: 'debora@email.com',
                          address: 'Santos Dumont, 695', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Dinheiro', description: 'Doces e tortas para alegrara sua vida')
    
    user2.update!(buffet_id: buffet2.id)

    user3 = User.create!(email: 'henrique@email.com', password: 'password3')
    buffet3 = Buffet.create!(name: 'Potinho de Ração', corporate_name: 'Babi festas e eventos', 
                          register_number: '98746456000145', phone: '53 991535353', email: 'babi@miau.com',
                          address: 'Rua dos gatos, 700', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro,', description: 'Serviço de Buffet saudável para pets')
    
    user3.update!(buffet_id: buffet3.id)

    event1 = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet1.id)
    event2 = Event.create!(name: 'Formatura', description: 'Serviço de mesa completo para formaturas', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet1.id)
    event3 = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet2.id)
    event4 = Event.create!(name: 'Aniversário', description: 'Serviço de mesa completo para aniversários', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet2.id)
    event5 = Event.create!(name: 'Chá Revelação', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet3.id)
    event6 = Event.create!(name: 'Eventos Corporativos', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet3.id)

    visit root_path
    fill_in 'Buscar Buffet', with: 'nto'
    click_on 'Buscar'

    expect(page).to have_content 'Vini'
    expect(page).to have_content 'Dé Licias'
    expect(page).to have_content 'Potinho de Ração'
  end

  it 'and go to details clicking in name' do
    user1 = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet1 = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user1.update!(buffet_id: buffet1.id)

    user2 = User.create!(email: 'debora@email.com', password: 'password2')
    buffet2 = Buffet.create!(name: 'Dé Licias', corporate_name: 'Débora Doces e tortas', 
                          register_number: '12412356000145', phone: '53 991549865', email: 'debora@email.com',
                          address: 'Santos Dumont, 695', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Dinheiro', description: 'Doces e tortas para alegrara sua vida')
    
    user2.update!(buffet_id: buffet2.id)

    user3 = User.create!(email: 'henrique@email.com', password: 'password3')
    buffet3 = Buffet.create!(name: 'Potinho de Ração', corporate_name: 'Babi festas e eventos', 
                          register_number: '98746456000145', phone: '53 991535353', email: 'babi@miau.com',
                          address: 'Rua dos gatos, 700', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro,', description: 'Serviço de Buffet saudável para pets')
    
    user3.update!(buffet_id: buffet3.id)

    event1 = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet1.id)
    event2 = Event.create!(name: 'Formatura', description: 'Serviço de mesa completo para formaturas', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet1.id)
    event3 = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet2.id)
    event4 = Event.create!(name: 'Aniversário', description: 'Serviço de mesa completo para aniversários', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet2.id)
    event5 = Event.create!(name: 'Chá Revelação', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet3.id)
    event6 = Event.create!(name: 'Eventos Corporativos', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet3.id)

    visit root_path
    fill_in 'Buscar Buffet', with: 'ini'
    click_on 'Buscar'
    click_on 'Vini'

    expect(current_path).to eq buffet_path(buffet1.id)
    expect(page).to have_content 'Nome: Vini'
  end
end