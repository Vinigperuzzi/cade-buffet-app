require "rails_helper"

describe 'user (customer or owner) interact with active and inactive events' do
  context 'customer interact with events' do
    it 'and sees active ones and do not see inactive ones' do
      user1 = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet1 = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      user1.update!(buffet_id: buffet1.id)

      event1 = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet1.id, active: true)
      event2 = Event.create!(name: 'Formatura',
        description: 'Serviço de mesa completo para formaturas',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet1.id, active: true)
      event3 = Event.create!(name: 'Aniversário',
        description: 'Serviço de mesa completo para aniversários',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet1.id, active: false)
      event4 = Event.create!(name: 'Chá Revelação',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet1.id, active: false)

      visit buffets_path
      click_on 'Lista de Buffets'
      click_on 'Vini'
      expect(page).to have_content 'Casamento'
      expect(page).to have_content 'Formatura'
      expect(page).not_to have_content 'Aniversário'
      expect(page).not_to have_content 'Chá Revelação'
    end

    it 'and cannot see a show page even via url' do
      user1 = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet1 = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      user1.update!(buffet_id: buffet1.id)

      event1 = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet1.id, active: false)

      visit event_path(event1.id)

      expect(page).to have_content "Este evento está inativo e portanto não está recebendo pedidos no momento."
      expect(page).to have_content "Para mais informações você pode tentar contatar o dono do buffet no e-mail: vinigperuzzi@gourmet.com"
    end
  end

  context 'owner interact with buffets' do
    it 'and see the inactivated events marked as such' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas', active: true)
      user.update!(buffet_id: buffet.id)
      event1 = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id, active: false)

      login_as user, scope: :user
      visit my_buffet_buffets_path

      expect(current_path).to eq my_buffet_buffets_path
      expect(page).to have_content "Casamento"
      expect(page).to have_content "⛔"
    end

    it "and see 'Desativar Evento' button" do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      user.update!(buffet_id: buffet.id)
      event1 = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id, active: true)

      login_as user, scope: :user
      visit event_path(event1.id)

      expect(page).to have_content "Desativar Evento"
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
      event1 = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id, active: true)

      login_as user, scope: :user
      visit event_path(event1.id)

      click_on "Desativar Evento"

      expect(current_path).to eq event_path(event1.id)
      expect(page).to have_content "Este evento está inativo e portanto não está recebendo pedidos no momento."
      expect(page).to have_content "Para mais informações você pode tentar contatar o dono do buffet no e-mail: vinigperuzzi@gourmet.com"
        expect(page).to have_content "Ativar Evento"
      expect(page).not_to have_content "Desativar Evento"
    end

    it 'and can active your own event' do
      user = User.create!(email: 'vinicius@email.com', password: 'password')
      buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
        register_number: '12456456000145', phone: '53 991814646',
        email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
        district: 'Laranjal', state: 'RS', city: 'Pelotas',
        payment_method: 'Pix, Débito, Crédito, Dinheiro',
        description: 'O melhor serviço de buffet do centro de Pelotas')
      user.update!(buffet_id: buffet.id)
      event1 = Event.create!(name: 'Casamento',
        description: 'Serviço de mesa completo para casamentos',
        min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id, active: false)

      login_as user, scope: :user
      visit event_path(event1.id)

      click_on "Ativar Evento"

      expect(current_path).to eq event_path(event1.id)
      expect(page).to have_content "Exibindo o Evento Casamento do Buffet Vini"
      expect(page).to have_content "Desativar Evento"
      expect(page).not_to have_content "Ativar Evento"
    end
  end
end