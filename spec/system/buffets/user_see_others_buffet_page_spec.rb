require "rails_helper"

describe "User visit another owner's event" do
  it 'and do not see a edit button' do
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

    login_as(user1)
    visit edit_buffet_path(buffet2.id)

    expect(page).not_to have_content 'Editar Evento'
  end
end