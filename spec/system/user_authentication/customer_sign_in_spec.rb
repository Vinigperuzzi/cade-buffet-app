require "rails_helper"

describe 'Customer authenticate itself' do
  it "and the account aren't registered yet" do
    visit root_path
    click_on 'Entrar'
    click_on 'Login como Cliente'
    within('main form') do
      fill_in 'E-mail', with: 'vinicius@email.com'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end
    expect(page).to have_content "E-mail ou senha inválidos."
  end

  it 'with success' do
    customer = Customer.create!(email: 'vinicius@email.com', password: 'password',
                                name: 'Vinícius Garcia Peruzzi', cpf: '03068810043')

    visit root_path
    click_on 'Entrar'
    click_on 'Login como Cliente'
    within('main form') do
      fill_in 'E-mail', with: 'vinicius@email.com'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end

    within("header nav #login-area") do
      expect(page).not_to have_button 'Entrar'
      expect(page).to have_button 'Sair'
      expect(page).to have_content 'Vinícius Garcia Peruzzi <vinicius@email.com>'
    end
    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).not_to have_content 'Meu Buffet'
  end

  it 'and logout' do
    customer = Customer.create!(email: 'vinicius@email.com', password: 'password',
                                name: 'Vinícius Garcia Peruzzi', cpf: '03068810043')
    
    login_as customer, scope: :customer
    visit root_path
    click_on 'Sair'

    within("header nav #login-area") do
      expect(page).to have_button 'Entrar'
      expect(page).not_to have_button 'Sair'
      expect(page).not_to have_content 'Vinícius Garcia Peruzzi <vinicius@email.com>'
    end
    expect(page).to have_content 'Logout efetuado com sucesso.'
  end
end