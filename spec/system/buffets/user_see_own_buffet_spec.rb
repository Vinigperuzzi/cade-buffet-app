require 'rails_helper'

describe "User see your own buffet" do
  it 'and are not authenticated' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
    register_number: '12456456000145', phone: '53 991814646',
    email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
    district: 'Laranjal', state: 'RS', city: 'Pelotas',
    payment_method: 'Pix, Débito, Crédito, Dinheiro',
    description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    visit my_buffet_buffets_path

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se.'
  end

  it "and can't see 'Meu buffet' button while not authenticated" do
    visit root_path

    expect(page).not_to have_button 'Meu Buffet'
  end

  it 'succesfully, from home' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
    register_number: '12456456000145', phone: '53 991814646',
    email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
    district: 'Laranjal', state: 'RS', city: 'Pelotas',
    payment_method: 'Pix, Débito, Crédito, Dinheiro',
    description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)

    login_as user, scope: :user
    visit root_path
    click_on 'Meu Buffet'

    expect(current_path).to eq my_buffet_buffets_path
    expect(page).to have_content 'Exibindo o Buffet Vini'
    expect(page).to have_content 'Nome: Vini'
    expect(page).to have_content 'Descrição: O melhor serviço de buffet do centro de Pelotas'
    expect(page).to have_content 'Razão Social: Vinícius Gourmet alimentos'
    expect(page).to have_content 'CNPJ: 12456456000145'
    expect(page).to have_content 'Telefone: 53 991814646'
    expect(page).to have_content 'E-mail: vinigperuzzi@gourmet.com'
    expect(page).to have_content 'Endereço: Estrada do Laranjal, 695'
    expect(page).to have_content 'Bairro: Laranjal'
    expect(page).to have_content 'Estado: RS'
    expect(page).to have_content 'Cidade: Pelotas'
    expect(page).to have_content 'Métodos de Pagamento: Pix, Débito, Crédito, Dinheiro'
  end
end