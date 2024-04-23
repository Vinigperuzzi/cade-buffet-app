require "rails_helper"

describe 'User deletes a event' do
  it 'with no price registered' do
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
    click_on 'Excluir Evento'

    expect(page).not_to have_content 'Casamento'
  end

  it 'With price registered' do
    pending "add some examples to (or delete) #{__FILE__}"
    expect(true).to eq false
  end
end