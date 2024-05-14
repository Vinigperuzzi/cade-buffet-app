require "rails_helper"

describe 'Someone access the system' do
  it "and fail trying to access messages unauthenticated by forcing url" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
      register_number: '12456456000145', phone: '53 991814646',
      email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
      district: 'Laranjal', state: 'RS', city: 'Pelotas',
      payment_method: 'Pix, Débito, Crédito, Dinheiro',
      description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento',
      description: 'Serviço de mesa completo para casamentos',
      min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
      buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000,
      sp_additional_person:500, additional_person:200,
      sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    customer = Customer.create!(email: 'cliente@email.com', password: 'password',
      name: 'cliente', cpf: '479.111.310-15')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id,
      event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
      event_details: 'Esse evento deve possuir toda a temática com corações rosa',
      address: '', order_status: :confirmed, final_price: 11000, extra_tax: 1000,
      discount: 500, customer_id: customer.id, out_doors: false)

    visit order_messages_path(order.id)
    
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content "Você precisa estar autenticado como dono de buffet ou cliente para ver os detalhes de um pedido."
  end

  it 'and fail trying to edit messages unauthenticated by forcing url' do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
      register_number: '12456456000145', phone: '53 991814646',
      email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
      district: 'Laranjal', state: 'RS', city: 'Pelotas',
      payment_method: 'Pix, Débito, Crédito, Dinheiro',
      description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event = Event.create!(name: 'Casamento',
      description: 'Serviço de mesa completo para casamentos',
      min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
      buffet_id: buffet.id)
    price = Price.create!(base_price: 5000, sp_base_price:6000,
      sp_additional_person:500, additional_person:200,
      sp_extra_hour:30, extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')

    order = Order.create!(buffet_id: buffet.id, event_id: event.id,
      event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
      event_details: 'Esse evento deve possuir toda a temática com corações rosa',
      address: '', order_status: :waiting, final_price: 11000, extra_tax: 1000,
      discount: 500, customer_id: customer.id, out_doors: false)
    message = Message.create!(order_id: order.id, sender: :user, customer_read: true,
      user_read: true, message_text: 'Olá, tudo bem?')

    visit edit_order_message_path(order_id: order.id, id: message.id)
    
    expect(current_path).to eq new_user_session_path
  end
end