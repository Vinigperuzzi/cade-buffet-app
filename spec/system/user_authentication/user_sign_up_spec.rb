require 'rails_helper'

describe 'User authenticate itself' do
  it 'with success' do
    visit root_path
    click_on 'Entrar'
    click_on 'Login como Dono de Buffet'
    click_on 'Criar uma conta'
    fill_in 'E-mail', with: 'vini@email.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    expect(page).to have_content 'Você precisa criar um Buffet para começar a utilizar a plataforma.'
    expect(page).to have_content 'vini@email.com'
    expect(page).to have_button 'Sair'
    user = User.last
    expect(user.email).to eq "vini@email.com"
  end
end