require "rails_helper"

describe 'user (customer or owner) interact with active and inactive buffets' do
  context 'customer interact with buffets' do
    it 'and sees active ones and do not see inactive ones' do
      user1 = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet1 = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      user1.update!(buffet_id: buffet1.id)

      user2 = User.create!(email: 'debora@email.com', password: 'password2')
      buffet2 = Buffet.create!(name: 'Dé Licias', corporate_name: 'Débora Doces e tortas', 
        register_number: '12412356000145', phone: '53 991549865',
        email: 'debora@email.com', address: 'Santos Dumont, 695',
        district: 'Centro', state: 'RS', city: 'Piratini',
        payment_method: 'Dinheiro',
        description: 'Doces e tortas para alegrara sua vida')
      user2.update!(buffet_id: buffet2.id)

      user3 = User.create!(email: 'henrique@email.com', password: 'password3')
      buffet3 = Buffet.create!(name: 'Potinho de Ração', corporate_name: 'Babi festas e eventos', 
        register_number: '98746456000145', phone: '53 991535353',
        email: 'babi@miau.com', address: 'Rua dos gatos, 700',
        district: 'Centro', state: 'RS', city: 'Piratini',
        payment_method: 'Pix, Débito, Crédito, Dinheiro,',
        description: 'Serviço de Buffet saudável para pets', active: false)
      user3.update!(buffet_id: buffet3.id)

      visit buffets_path
      expect(page).to have_content "Vini"
      expect(page).to have_content "Dé Licias"
      expect(page).not_to have_content "Potinho de Ração"
    end

    it 'and obtain results for actives ones and not for inactive ones in search' do
      user1 = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet1 = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      user1.update!(buffet_id: buffet1.id)

      user2 = User.create!(email: 'debora@email.com', password: 'password2')
      buffet2 = Buffet.create!(name: 'Dé Licias', corporate_name: 'Débora Doces e tortas', 
        register_number: '12412356000145', phone: '53 991549865',
        email: 'debora@email.com', address: 'Santos Dumont, 695',
        district: 'Centro', state: 'RS', city: 'Piratini',
        payment_method: 'Dinheiro',
        description: 'Doces e tortas para alegrara sua vida')
      user2.update!(buffet_id: buffet2.id)

      user3 = User.create!(email: 'henrique@email.com', password: 'password3')
      buffet3 = Buffet.create!(name: 'Potinho de Ração', corporate_name: 'Babi festas e eventos', 
        register_number: '98746456000145', phone: '53 991535353',
        email: 'babi@miau.com', address: 'Rua dos gatos, 700',
        district: 'Centro', state: 'RS', city: 'Piratini',
        payment_method: 'Pix, Débito, Crédito, Dinheiro,',
        description: 'Serviço de Buffet saudável para pets', active: false)
      user3.update!(buffet_id: buffet3.id)

      visit root_path
      fill_in 'Buscar Buffet', with: 'i'
      click_on 'Buscar'

      expect(page).to have_content 'Vini'
      expect(page).to have_content 'Dé Licias'
      expect(page).not_to have_content 'Potinho de Ração'
    end

    it 'and cannot see a show page even via url' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas', active: false)
      user.update!(buffet_id: buffet.id)

      visit buffet_path(buffet.id)

      expect(page).to have_content "Este Buffet está inativo e portanto não está recebendo pedidos no momento."
      expect(page).to have_content "Para mais informações você pode tentar contatar o dono do buffet no e-mail: vinigperuzzi@gourmet.com"
    end
  end

  context 'owner interact with buffets' do
    it "and see 'Desativar Buffet' button" do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas', active: true)
      user.update!(buffet_id: buffet.id)

      login_as user, scope: :user
      visit my_buffet_buffets_path

      expect(page).to have_content "Desativar Buffet"
    end

    it 'and can inactive your own buffet' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas', active: true)
      user.update!(buffet_id: buffet.id)

      login_as user, scope: :user
      visit my_buffet_buffets_path

      click_on "Desativar Buffet"

      expect(current_path).to eq my_buffet_buffets_path
      expect(page).to have_content "Este Buffet está inativo e portanto não está recebendo pedidos no momento."
      expect(page).to have_content "Para mais informações você pode tentar contatar o dono do buffet no e-mail: vinigperuzzi@gourmet.com"
      expect(page).to have_content "Ativar Buffet"
    end

    it 'and can active your own buffet' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas', active: false)
      user.update!(buffet_id: buffet.id)

      login_as user, scope: :user
      visit my_buffet_buffets_path

      click_on "Ativar Buffet"

      expect(current_path).to eq my_buffet_buffets_path
      expect(page).not_to have_content "Este Buffet está inativo e portanto não está recebendo pedidos no momento."
      expect(page).not_to have_content "Para mais informações você pode tentar contatar o dono do buffet no e-mail: vinigperuzzi@gourmet.com"
      expect(page).not_to have_content "Ativar Buffet"
      expect(page).to have_content "Desativar Buffet"
    end
  end
end