require "rails_helper"

describe "Guest see the buffet's list" do
  it 'and see all of them' do
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

    visit root_path
    click_on 'Lista de Buffets'

    expect(page).to have_content 'Vini'
    expect(page).to have_content 'Pelotas'
    expect(page).to have_content 'RS'
    expect(page).to have_content 'Potinho de Ração'
    expect(page).to have_content 'Piratini'
    expect(page).to have_content 'RS'
    expect(page).to have_content 'Dé Licias'
    expect(page).to have_content 'Piratini'
    expect(page).to have_content 'RS'
  end

  it 'and see details but no corporate_name' do
    user1 = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet1 = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user1.update!(buffet_id: buffet1.id)
    buffet2 = Buffet.create!(name: 'Potinho de Ração', corporate_name: 'Babi festas e eventos', 
                          register_number: '98746456000145', phone: '53 991535353', email: 'babi@miau.com',
                          address: 'Rua dos gatos, 700', district: 'Centro', state: 'RS', city: 'Piratini',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro,', description: 'Serviço de Buffet saudável para pets')
    user1.update!(buffet_id: buffet2.id)

    visit root_path
    click_on 'Lista de Buffets'
    click_on 'Vini'

    expect(page).to have_content 'Nome: Vini'
    expect(page).to have_content 'Descrição: O melhor serviço de buffet do centro de Pelotas'
    expect(page).to have_content 'CNPJ: 12456456000145'
    expect(page).to have_content 'Telefone: 53 991814646'
    expect(page).to have_content 'E-mail: vinigperuzzi@gourmet.com'
    expect(page).to have_content 'Endereço: Estrada do Laranjal, 695'
    expect(page).to have_content 'Bairro: Laranjal'
    expect(page).to have_content 'Estado: RS'
    expect(page).to have_content 'Cidade: Pelotas'
    expect(page).to have_content 'Métodos de Pagamento: Pix, Débito, Crédito, Dinheiro'
    expect(page).not_to have_content 'Vinícius Gourmet alimentos'
  end
end