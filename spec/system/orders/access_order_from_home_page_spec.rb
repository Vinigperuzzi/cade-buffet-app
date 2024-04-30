require "rails_helper"

describe 'A person access home page' do
  it 'and are not authenticated (do not see any button)' do
    visit root_path

    expect(page).not_to have_content 'Meus Pedidos'
    expect(page).not_to have_content 'Pedidos'
  end

  it "and are authenticated as user (must see 'Pedidos' button)" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)

    login_as user, scope: :user
    visit root_path

    expect(page).to have_content 'Pedidos'
    expect(page).not_to have_content 'Meus Pedidos'
  end

  it "and are authenticated as customer (must see 'Meus Pedidos' button)" do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')

    login_as customer, scope: :customer
    visit root_path

    expect(page).to have_content 'Meus Pedidos'
    expect(page).not_to have_button 'Pedidos'
  end
end