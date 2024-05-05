require "rails_helper"

describe 'Customer access chat' do
  it "and can see chat button" do
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
    customer = Customer.create!(email: 'cliente@email.com', password: 'password', name: 'cliente', cpf: '479.111.310-15')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id, event_date: Date.new(2134, 5, 1), estimated_qtd: 30,
                          event_details: 'Esse evento deve possuir toda a temática com corações rosa', address: '', order_status: :confirmed,
                          final_price: 11000, extra_tax: 1000, discount: 500, customer_id: customer.id, out_doors: false)

    login_as customer, scope: :customer
    visit order_path(order.id)
    
    expect(page).to have_link "Conversar com o buffet sobre esse pedido"
  end

  it "and must be authenticated" do
    pending ""
    expect(true).to eq false
  end

  it "and access chat page for only it's own order's chat" do
    pending ""
    expect(true).to eq false
  end

  it "and can see order's code, buffet's, event's and customer's name and event's date" do
    pending ""
    expect(true).to eq false
  end

  it "and can see it's own messages" do
    pending ""
    expect(true).to eq false
  end

  it "and can see messages send by customer and responde" do
    pending ""
    expect(true).to eq false
  end

  it "and can send messages" do
    pending ""
    expect(true).to eq false
  end

  it "and can see message's sent time" do
    pending ""
    expect(true).to eq false
  end

  it "and can edit a message and see edit time" do
    pending ""
    expect(true).to eq false
  end

  it "and can see messages marked as visualized" do
    pending ""
    expect(true).to eq false
  end
end