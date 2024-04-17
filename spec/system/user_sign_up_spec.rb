require 'rails_helper'

describe 'Usuário se autentica' do
  it 'com sucesso' do
    visit root_path
    click_on 'Entrar'
    click_on 'Login como Dono de Buffet'
    click_on 'Criar uma conta'
    fill_in 'E-mail', with: 'vini@email.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
    expect(page).to have_content 'vini@email.com'
    expect(page).to have_button 'Sair'
    user = User.last
    expect(user.email).to eq "vini@email.com"
  end
end