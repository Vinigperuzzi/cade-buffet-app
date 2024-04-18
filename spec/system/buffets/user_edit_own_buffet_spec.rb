require 'rails_helper'

describe 'User edit its own buffet' do
  it 'and are not authenticated' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)

    visit edit_buffet_path(buffet.id)
    
    expect(current_path).to eq new_user_session_path
  end

  it 'and cannot edit others buffet' do
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

    login_as(user1)
    visit edit_buffet_path(buffet2.id)

    expect(page).to have_content 'Editar o Buffet Vini'
    expect(page).not_to have_content 'Editar o Buffet Dé Licias'
  end

  it 'succesfully, from home page' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)

    login_as(user)
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Editar Buffet'
    fill_in 'E-mail', with: 'vinigperuzzi@email.com'
    click_on 'Salvar Buffet'

    expect(current_path).to eq my_buffet_buffets_path
    expect(page).to have_content 'Buffet atualizado com sucesso.'
    expect(page).to have_content 'Exibindo o Buffet Vini'
    expect(page).to have_content 'Nome: Vini'
    expect(page).to have_content 'Descrição: O melhor serviço de buffet do centro de Pelotas'
    expect(page).to have_content 'Razão Social: Vinícius Gourmet alimentos'
    expect(page).to have_content 'CNPJ: 12456456000145'
    expect(page).to have_content 'Telefone: 53 991814646'
    expect(page).to have_content 'E-mail: vinigperuzzi@email.com'
    expect(page).to have_content 'Endereço: Estrada do Laranjal, 695'
    expect(page).to have_content 'Bairro: Laranjal'
    expect(page).to have_content 'Estado: RS'
    expect(page).to have_content 'Cidade: Pelotas'
    expect(page).to have_content 'Métodos de Pagamento: Pix, Débito, Crédito, Dinheiro'
  end
end