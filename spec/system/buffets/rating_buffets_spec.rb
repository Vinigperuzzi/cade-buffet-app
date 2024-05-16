require "rails_helper"

describe "user access order's page" do
  context 'as customer' do
    it "and sees a 'Avaliar Buffet' button after an confirmed event date" do
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
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
        sp_additional_person:500, additional_person:200, sp_extra_hour:30,
        extra_hour:20, event_id: event.id)
      album = Album.create!(event_id: event.id)
      album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: 1.day.from_now, estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :confirmed, final_price: 11000, extra_tax: 1000,
        discount: 500, customer_id: customer.id, out_doors: false)
  
      travel_to 2.days.from_now do
        login_as customer, scope: :customer
        visit root_path
        click_on "Meus Pedidos"
        click_on "Mostrar Detalhes"
      end
  
      expect(page).to have_content "Avaliar Buffet"
      travel_back
    end
  
    it "and do not see a 'Avaliar Buffet' button before an confirmed event date" do
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
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
        sp_additional_person:500, additional_person:200, sp_extra_hour:30,
        extra_hour:20, event_id: event.id)
      album = Album.create!(event_id: event.id)
      album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: 1.day.from_now, estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :confirmed, final_price: 11000, extra_tax: 1000,
        discount: 500, customer_id: customer.id, out_doors: false)
  
      login_as customer, scope: :customer
      visit root_path
      click_on "Meus Pedidos"
      click_on "Mostrar Detalhes"
  
      expect(page).not_to have_content "Avaliar Buffet"
    end
  
    it "and do not see a 'Avaliar Buffet' button after an canceled event date" do
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
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
        sp_additional_person:500, additional_person:200, sp_extra_hour:30,
        extra_hour:20, event_id: event.id)
      album = Album.create!(event_id: event.id)
      album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: 1.day.from_now, estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :canceled, final_price: 11000, extra_tax: 1000,
        discount: 500, customer_id: customer.id, out_doors: false)
  
      travel_to 2.days.from_now do
        login_as customer, scope: :customer
        visit root_path
        click_on "Meus Pedidos"
        click_on "Mostrar Detalhes"
      end
  
      expect(page).not_to have_content "Avaliar Buffet"
      travel_back
    end
  end
  context 'as owner' do
    it "and do not see a 'Avaliar Buffet' button after an confirmed event date signed as owner" do
      customer = Customer.create!(email: 'cliente@email.com', password: 'password',
        name: 'cliente', cpf: '479.111.310-15')
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
        sp_additional_person:500, additional_person:200, sp_extra_hour:30,
        extra_hour:20, event_id: event.id)
      album = Album.create!(event_id: event.id)
      album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
      order = Order.create!(buffet_id: buffet.id, event_id: event.id,
        event_date: 1.day.from_now, estimated_qtd: 30,
        event_details: 'Esse evento deve possuir toda a temática com corações rosa',
        address: '', order_status: :confirmed, final_price: 11000, extra_tax: 1000,
        discount: 500, customer_id: customer.id, out_doors: false)
  
      travel_to 2.days.from_now do
        login_as user, scope: :user
        visit root_path
        click_on "Pedidos"
        click_on "Mostrar Detalhes"
      end
  
      expect(page).not_to have_content "Avaliar Buffet"
      travel_back
    end
  end
end

describe "and see the rating page (even via force url)" do
  it 'and see page for an past confirmed event' do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password',
      name: 'cliente', cpf: '479.111.310-15')
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
      sp_additional_person:500, additional_person:200, sp_extra_hour:30,
      extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id,
      event_date: 1.day.from_now, estimated_qtd: 30,
      event_details: 'Esse evento deve possuir toda a temática com corações rosa',
      address: '', order_status: :confirmed, final_price: 11000, extra_tax: 1000,
      discount: 500, customer_id: customer.id, out_doors: false)

    travel_to 2.days.from_now do
      login_as customer, scope: :customer
      visit root_path
      click_on "Meus Pedidos"
      click_on "Mostrar Detalhes"
      click_on "Avaliar Buffet"
    end

    expect(page).to have_content "Avaliar o Buffet Vini"
    travel_back
  end

  it 'and do not see the page for an confirmed past event' do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password',
      name: 'cliente', cpf: '479.111.310-15')
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
      sp_additional_person:500, additional_person:200, sp_extra_hour:30,
      extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id,
      event_date: 2.day.from_now, estimated_qtd: 30,
      event_details: 'Esse evento deve possuir toda a temática com corações rosa',
      address: '', order_status: :confirmed, final_price: 11000, extra_tax: 1000,
      discount: 500, customer_id: customer.id, out_doors: false)

    travel_to 1.days.from_now do
      login_as customer, scope: :customer
      visit rate_buffet_path(order.buffet_id, order_id: order.id)
    end

    expect(current_path).to eq root_path
    expect(page).to have_content "Você não pode avaliar esse Buffet."
    travel_back
  end

  it 'and do not see the page for an not confirmed future event' do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password',
      name: 'cliente', cpf: '479.111.310-15')
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
      sp_additional_person:500, additional_person:200, sp_extra_hour:30,
      extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id,
      event_date: 1.day.from_now, estimated_qtd: 30,
      event_details: 'Esse evento deve possuir toda a temática com corações rosa',
      address: '', order_status: :canceled, final_price: 11000, extra_tax: 1000,
      discount: 500, customer_id: customer.id, out_doors: false)

    travel_to 2.days.from_now do
      login_as customer, scope: :customer
      visit rate_buffet_path(order.buffet_id, order_id: order.id)
    end

    expect(current_path).to eq root_path
    expect(page).to have_content "Você não pode avaliar esse Buffet."
    travel_back
  end

  it 'and do not see the page for an event not ordered by self' do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password',
      name: 'cliente', cpf: '479.111.310-15')
    customer2 = Customer.create!(email: 'cliente2@email.com', password: 'password2',
      name: 'cliente2', cpf: '325.066.805-27')
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
      sp_additional_person:500, additional_person:200, sp_extra_hour:30,
      extra_hour:20, event_id: event.id)
    album = Album.create!(event_id: event.id)
    album.images.attach(io: File.open(Rails.root.join('spec', 'support', 'festa_casamento.jpg')), filename: 'festa_casamento.jpg')
    order = Order.create!(buffet_id: buffet.id, event_id: event.id,
      event_date: 1.day.from_now, estimated_qtd: 30,
      event_details: 'Esse evento deve possuir toda a temática com corações rosa',
      address: '', order_status: :confirmed, final_price: 11000, extra_tax: 1000,
      discount: 500, customer_id: customer.id, out_doors: false)

    travel_to 2.days.from_now do
      login_as customer2, scope: :customer
      visit rate_buffet_path(order.buffet_id, order_id: order.id)
    end

    expect(current_path).to eq root_path
    expect(page).to have_content "Você não pode avaliar esse Buffet."
    travel_back
  end
end