require 'rails_helper'

describe "User register a buffet for it's own account" do
  it 'and are not authenticated' do
    visit new_buffet_path
    
    expect(current_path).to eq new_user_session_path
  end

  it 'and do not see any advise messages for inputs at first' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')

    login_as(user)
    visit new_buffet_path

    expect(page).not_to have_content 'Não foi possível registrar o Buffet.'
    expect(page).not_to have_content 'Nome não pode ficar em branco'
    expect(page).not_to have_content 'Razão Social não pode ficar em branco'
    expect(page).not_to have_content 'CNPJ não pode ficar em branco'
    expect(page).not_to have_content 'Telefone não pode ficar em branco'
    expect(page).not_to have_content 'E-mail não pode ficar em branco'
    expect(page).not_to have_content 'Endereço não pode ficar em branco'
    expect(page).not_to have_content 'Bairro não pode ficar em branco'
    expect(page).not_to have_content 'Estado não pode ficar em branco'
    expect(page).not_to have_content 'Cidade não pode ficar em branco'
    expect(page).not_to have_content 'Formas de Pagamento não pode ficar em branco'
    expect(page).not_to have_content 'Descrição não pode ficar em branco'
  end

  it 'with obrigatory fields empty' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')

    login_as(user)
    visit new_buffet_path
    fill_in 'Nome', with: ''
    fill_in 'Razão Social', with: ''
    fill_in 'CNPJ', with: ''
    fill_in 'Telefone', with: ''
    click_on 'Salvar Buffet'

    expect(current_path).to eq buffets_path
    expect(page).to have_content 'Não foi possível registrar o Buffet.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Razão Social não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
    expect(page).to have_content 'Telefone não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Endereço não pode ficar em branco'
    expect(page).to have_content 'Bairro não pode ficar em branco'
    expect(page).to have_content 'Estado não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'Formas de Pagamento não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
  end

  it 'and the advise message disapear for a filled input' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')

    login_as(user)
    visit new_buffet_path
    fill_in 'Nome', with: 'Vinícius Gourmet'
    fill_in 'Razão Social', with: ''
    click_on 'Salvar Buffet'

    expect(page).not_to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Razão Social não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
    expect(page).to have_content 'Telefone não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Endereço não pode ficar em branco'
    expect(page).to have_content 'Bairro não pode ficar em branco'
    expect(page).to have_content 'Estado não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'Formas de Pagamento não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
  end

  it 'succesfully, directly redirect after login' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')

    login_as(user)
    visit new_buffet_path
    fill_in 'Nome', with: 'Vinícius Gourmet'
    fill_in 'Razão Social', with: 'Vinícius Gourmet alimentos'
    fill_in 'CNPJ', with: '12456456000145'
    fill_in 'Telefone', with: '53 991814646'
    fill_in 'E-mail', with: 'vini@email.com'
    fill_in 'Endereço', with: 'Estrada do Laranjal, 695'
    fill_in 'Bairro', with: 'Laranjal'
    fill_in 'Estado', with: 'RS'
    fill_in 'Cidade', with: 'Pelotas'
    fill_in 'Formas de Pagamento', with: 'Crédito, Débito, Pix, Dinheiro'
    fill_in 'Descrição', with: 'O melhor serviço de buffet de Pelotas'
    click_on 'Salvar Buffet'
    
    expect(page).to have_content "Buffet registrado com sucesso."
    expect(current_path).to eq root_path
  end

  it 'and tries to register again' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)

    login_as(user)
    visit new_buffet_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Já existe um Buffet cadastrado para esse usuário.'
  end
end