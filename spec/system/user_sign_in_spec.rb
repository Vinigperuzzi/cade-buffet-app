require 'rails_helper'

describe 'Usuário se autentica' do
  it 'com sucesso' do
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
    expect(page).to have_content 'Login efetuado com sucesso.'
  end

  it 'e faz logout' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    
    login_as(user)
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