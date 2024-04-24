require 'rails_helper'

describe 'User authenticate itself' do
  it 'with success but before register a buffet' do
    User.create!(email: 'vinicius@email.com', password: 'password')

    visit root_path
    click_on 'Entrar'
    click_on 'Login como Dono de Buffet'
    within('main form') do
      fill_in 'E-mail', with: 'vinicius@email.com'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end

    within("header nav #login-area") do
      expect(page).not_to have_button 'Entrar'
      expect(page).to have_button 'Sair'
      expect(page).to have_content 'vinicius@email.com'
    end
    expect(page).to have_content 'Você precisa criar um Buffet para começar a utilizar a plataforma.'
  end

  it 'with success but after register a buffet' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)

    visit root_path
    click_on 'Entrar'
    click_on 'Login como Dono de Buffet'
    within('main form') do
      fill_in 'E-mail', with: 'vinicius@email.com'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end

    within("header nav #login-area") do
      expect(page).not_to have_button 'Entrar'
      expect(page).to have_button 'Sair'
      expect(page).to have_content 'vinicius@email.com'
    end
    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).to have_content 'Meu Buffet'
  end

  it 'and logout' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    
    login_as user, scope: :user
    visit root_path
    click_on 'Sair'

    within("header nav #login-area") do
      expect(page).to have_button 'Entrar'
      expect(page).not_to have_button 'Sair'
      expect(page).not_to have_content 'vinicius@email.com'
    end
    expect(page).to have_content 'Logout efetuado com sucesso.'
  end
end