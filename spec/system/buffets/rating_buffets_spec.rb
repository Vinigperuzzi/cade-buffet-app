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
  
      travel_to 4.days.from_now do
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
  
      travel_to 4.days.from_now do
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
  
      travel_to 4.days.from_now do
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

    travel_to 4.days.from_now do
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
      event_date: 3.day.from_now, estimated_qtd: 30,
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

    travel_to 4.days.from_now do
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

    travel_to 4.days.from_now do
      login_as customer2, scope: :customer
      visit rate_buffet_path(order.buffet_id, order_id: order.id)
    end

    expect(current_path).to eq root_path
    expect(page).to have_content "Você não pode avaliar esse Buffet."
    travel_back
  end
end

describe "and can rate a buffet" do
  it 'succesfully' do
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

    travel_to 4.days.from_now do
      login_as customer, scope: :customer
      visit root_path
      click_on "Meus Pedidos"
      click_on "Mostrar Detalhes"
      click_on "Avaliar Buffet"
      fill_in 'Pontuação', with: 5
      fill_in 'Comentário', with: 'Muito bom!'
      attach_file 'Imagens', Rails.root.join('spec', 'support', 'festa_casamento2.jpg')
      click_on 'Salvar Avaliação'
    end

    expect(current_path).to eq buffet_path(buffet.id)
    expect(page).to have_content 'Obrigado por avaliar!'
    expect(Rate.last.score).to eq 5
    expect(Rate.last.review).to eq "Muito bom!"
    travel_back
  end

  it 'and can edit' do
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
    rate = Rate.create!(score: 5, review: "Muito bom",
      buffet_id: buffet.id, customer_id: customer.id)

    travel_to 4.days.from_now do
      login_as customer, scope: :customer
      visit root_path
      click_on "Meus Pedidos"
      click_on "Mostrar Detalhes"
      click_on "Avaliar Buffet"
      fill_in 'Pontuação', with: 3
      fill_in 'Comentário', with: 'Regular'
      attach_file 'Imagens', Rails.root.join('spec', 'support', 'festa_casamento2.jpg')
      click_on 'Salvar Avaliação'
    end

    expect(current_path).to eq buffet_path(buffet.id)
    expect(page).to have_content 'Obrigado por avaliar!'
    expect(Rate.last.score).to eq 3
    expect(Rate.last.review).to eq "Regular"
    travel_back
  end

  it 'and fails blank fields' do
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

    travel_to 4.days.from_now do
      login_as customer, scope: :customer
      visit root_path
      click_on "Meus Pedidos"
      click_on "Mostrar Detalhes"
      click_on "Avaliar Buffet"
      click_on 'Salvar Avaliação'
    end

    expect(current_path).to eq rate_buffet_path(buffet.id)
    expect(page).to have_content 'Erro ao avaliar.'
    travel_back
  end

  it 'and see up to 3 ratings in buffets show page' do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password',
      name: 'cliente', cpf: '479.111.310-15')
    customer2 = Customer.create!(email: 'cliente2@email.com', password: 'password2',
      name: 'cliente2', cpf: '325.066.805-27')
    customer3 = Customer.create!(email: 'cliente3@email.com', password: 'password3',
      name: 'cliente3', cpf: '262.089.290-24')
    customer4 = Customer.create!(email: 'cliente4@email.com', password: 'password4',
      name: 'cliente4', cpf: '900.548.290-70')
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
    rate = Rate.create!(score: 5, review: "Muito bom",
      buffet_id: buffet.id, customer_id: customer.id)
    rate1 = Rate.create!(score: 4, review: "Bom",
      buffet_id: buffet.id, customer_id: customer2.id)
    rate2 = Rate.create!(score: 2, review: "Ruim",
      buffet_id: buffet.id, customer_id: customer3.id)
    rate2 = Rate.create!(score: 2, review: "Não gostei",
      buffet_id: buffet.id, customer_id: customer4.id)

    visit root_path
    click_on 'Lista de Buffets'
    click_on "Vini"

    expect(page).to have_content 'Avaliação: 3.3'
    expect(page).to have_content 'Bom'
    expect(page).to have_content 'Ruim'
    expect(page).to have_content 'Não gostei'
    expect(page).to have_content 'Mostrar todas'
    expect(page).not_to have_content 'Muito bom'
  end

  it 'and all ratings in the index ratings page' do
    customer = Customer.create!(email: 'cliente@email.com', password: 'password',
      name: 'cliente', cpf: '479.111.310-15')
    customer2 = Customer.create!(email: 'cliente2@email.com', password: 'password2',
      name: 'cliente2', cpf: '325.066.805-27')
    customer3 = Customer.create!(email: 'cliente3@email.com', password: 'password3',
      name: 'cliente3', cpf: '262.089.290-24')
    customer4 = Customer.create!(email: 'cliente4@email.com', password: 'password4',
      name: 'cliente4', cpf: '900.548.290-70')
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
    rate = Rate.create!(score: 5, review: "Muito bom",
      buffet_id: buffet.id, customer_id: customer.id)
    rate1 = Rate.create!(score: 4, review: "Bom",
      buffet_id: buffet.id, customer_id: customer2.id)
    rate2 = Rate.create!(score: 2, review: "Ruim",
      buffet_id: buffet.id, customer_id: customer3.id)
    rate2 = Rate.create!(score: 2, review: "Não gostei",
      buffet_id: buffet.id, customer_id: customer4.id)

    visit root_path
    click_on 'Lista de Buffets'
    click_on "Vini"
    click_on 'Mostrar todas'

    expect(page).to have_content 'Bom'
    expect(page).to have_content 'Ruim'
    expect(page).to have_content 'Não gostei'
    expect(page).to have_content 'Muito bom'
    expect(page).to have_content 'Voltar'
  end
end