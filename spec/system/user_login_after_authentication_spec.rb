require 'rails_helper'

describe 'User connect to aplication after authenticate itself' do
  it 'and has not registered a buffet yet' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    
    login_as(user)
    visit root_path
    
    expect(current_path).to eq new_buffet_path
    expect(page).to have_content 'Você precisa criar um Buffet para começar a utilizar a plataforma.'
  end

  it 'cannot see own buffet page (or any other) with no buffet registered yet' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    
    login_as(user)
    visit root_path
    click_on 'Meu Buffet'
    
    expect(current_path).to eq new_buffet_path
    expect(page).to have_content 'Você precisa criar um Buffet para começar a utilizar a plataforma.'
  end

  it 'already registered a buffet' do
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

    expect(current_path).to eq root_path
    expect(page).to have_content 'Login efetuado com sucesso.'
  end
end