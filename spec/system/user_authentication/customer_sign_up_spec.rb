require 'rails_helper'

describe 'Customer authenticate itself' do
  it 'with success' do
    visit root_path
    click_on 'Entrar'
    click_on 'Login como Cliente'
    click_on 'Criar uma conta'
    fill_in 'E-mail', with: 'vini@email.com'
    fill_in 'Nome', with: 'Vinícius Garcia Peruzzi'
    fill_in 'CPF', with: '03068810043'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    within("header nav #login-area") do
      expect(page).not_to have_button 'Entrar'
      expect(page).to have_button 'Sair'
      expect(page).to have_content 'Vinícius Garcia Peruzzi <vini@email.com>'
    end
    customer = Customer.last
    expect(customer.email).to eq "vini@email.com"
  end

  it 'and fails because of blank custom inputs' do
    visit root_path
    click_on 'Entrar'
    click_on 'Login como Cliente'
    click_on 'Criar uma conta'
    fill_in 'E-mail', with: 'vini@email.com'
    fill_in 'Nome', with: ''
    fill_in 'CPF', with: ''
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'CPF não pode ficar em branco'
  end

  it 'and fails because of invalid cpf' do
    visit root_path
    click_on 'Entrar'
    click_on 'Login como Cliente'
    click_on 'Criar uma conta'
    fill_in 'E-mail', with: 'vini@email.com'
    fill_in 'Nome', with: 'Vinícius Garcia Peruzzi'
    fill_in 'CPF', with: '02002002020'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    expect(page).to have_content 'CPF deve ser válido'
  end

  it 'and fails because of email has been registered already' do
    customer = Customer.create!(email: 'vini@email.com', password: 'password',
                                name: 'Vinícius Garcia Peruzzi', cpf: '03068810043')
    visit root_path
    click_on 'Entrar'
    click_on 'Login como Cliente'
    click_on 'Criar uma conta'
    fill_in 'E-mail', with: 'vini@email.com'
    fill_in 'Nome', with: 'Vinícius Garcia Peruzzi'
    fill_in 'CPF', with: '03068810043'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    expect(page).to have_content 'E-mail já está em uso'
  end

  it 'and fails because of cpf has been registered already' do
    customer = Customer.create!(email: 'vini@email.com', password: 'password',
                                name: 'Vinícius Garcia Peruzzi', cpf: '03068810043')
    visit root_path
    click_on 'Entrar'
    click_on 'Login como Cliente'
    click_on 'Criar uma conta'
    fill_in 'E-mail', with: 'dedi@email.com'
    fill_in 'Nome', with: 'Vinícius Garcia Peruzzi'
    fill_in 'CPF', with: '03068810043'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    expect(page).to have_content 'CPF já está em uso'
  end
end