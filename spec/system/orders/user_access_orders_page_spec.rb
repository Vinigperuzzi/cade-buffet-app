require "rails_helper"

describe "User see order's list" do

  it "and do not see a 'Realizar Pedido' button" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
                          register_number: '12456456000145', phone: '53 991814646', email: 'vinigperuzzi@gourmet.com',
                          address: 'Estrada do Laranjal, 695', district: 'Laranjal', state: 'RS', city: 'Pelotas',
                          payment_method: 'Pix, Débito, Crédito, Dinheiro', description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento', description: 'Serviço de mesa completo para casamentos', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Frutos do Mar', buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000, sp_additional_person:500,
                          additional_person:200, sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')

    login_as user, scope: :user
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Mostrar Detalhes'

    expect(page).not_to have_button 'Realizar Pedido'
  end

  it "and only see orders for own events" do
    pending
    expect(true).to eq false
  end

  it "and see the pending ones first" do
    pending
    expect(true).to eq false
  end

  it "and see details from any pending order" do
    pending
    expect(true).to eq false
  end

  it "and see an alert if already has an event on current order's day day" do
    pending
    expect(true).to eq false
  end

  it "and can evaluate an event" do
    pending
    expect(true).to eq false
  end
end