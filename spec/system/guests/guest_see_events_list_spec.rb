require "rails_helper"

describe "User see the events list in buffet's details" do
  it 'and see names, max quantity and base price' do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
      register_number: '12456456000145', phone: '53 991814646',
      email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
      district: 'Laranjal', state: 'RS', city: 'Pelotas',
      payment_method: 'Pix, Débito, Crédito, Dinheiro',
      description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event1 = Event.create!(name: 'Casamento',
      description: 'Serviço de mesa completo para casamentos',
      min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
      buffet_id: buffet.id)
    price1 = Price.create!(base_price: 5000, sp_base_price:6000,
      sp_additional_person:500, additional_person:200, sp_extra_hour:30,
      extra_hour:20, event_id: event1.id)
    event2 = Event.create!(name: 'Formatura',
      description: 'Solenidades elegantes',
      min_qtd: 20, max_qtd: 80, duration: 250, menu: 'Frutos do Mar',
      buffet_id: buffet.id)
    price2 = Price.create!(base_price: 6000, sp_base_price: 7000,
      sp_additional_person: 300, additional_person: 100,
      sp_extra_hour: 80, extra_hour: 60, event_id: event2.id)
    event3 = Event.create!(name: 'Eventos corporativos',
      description: 'Buffet para situações profissionais',
      min_qtd: 20, max_qtd: 60, duration: 250, menu: 'Frutos do Mar',
        buffet_id: buffet.id)
    price3 = Price.create!(base_price: 2500, sp_base_price:6000,
      sp_additional_person:500, additional_person:200, sp_extra_hour:30,
      extra_hour:20, event_id: event3.id)

    visit root_path
    click_on 'Lista de Buffets'
    click_on 'Vini'
    expect(page).to have_content 'Casamento'
    expect(page).to have_content 'Serviço de mesa completo para casamentos'
    expect(page).to have_content 'Capacidade Máxima: 40'
    expect(page).to have_content 'A partir de: R$ 5000,00'
    expect(page).to have_content 'Formatura'
    expect(page).to have_content 'Solenidades elegantes'
    expect(page).to have_content 'Capacidade Máxima: 80'
    expect(page).to have_content 'A partir de: R$ 6000,00'
    expect(page).to have_content 'Eventos corporativos'
    expect(page).to have_content 'Buffet para situações profissionais'
    expect(page).to have_content 'Capacidade Máxima: 60'
    expect(page).to have_content 'A partir de: R$ 2500,00'
  end

  it "and see event's details" do
    user = User.create!(email: 'vinicius@email.com', password: 'password')
    buffet = Buffet.create!(name: 'Vini', corporate_name: 'Vinícius Gourmet alimentos', 
      register_number: '12456456000145', phone: '53 991814646',
      email: 'vinigperuzzi@gourmet.com', address: 'Estrada do Laranjal, 695',
      district: 'Laranjal', state: 'RS', city: 'Pelotas',
      payment_method: 'Pix, Débito, Crédito, Dinheiro',
      description: 'O melhor serviço de buffet do centro de Pelotas')
    user.update!(buffet_id: buffet.id)
    event1 = Event.create!(name: 'Casamento',
      description: 'Serviço de mesa completo para casamentos',
      min_qtd: 20, max_qtd: 40, duration: 250, menu: 'Frutos do Mar',
      buffet_id: buffet.id)
    price1 = Price.create!(base_price: 5000, sp_base_price:6000,
      sp_additional_person:500, additional_person:200, sp_extra_hour:30,
      extra_hour:20, event_id: event1.id)

    visit root_path
    click_on 'Lista de Buffets'
    click_on 'Vini'
    click_on 'Mostrar Detalhes'

    expect(page).to have_content 'Nome: Casamento'
    expect(page).to have_content 'Descrição: Serviço de mesa completo para casamentos'
    expect(page).to have_content 'Quantidade mínima de pessoas: 20'
    expect(page).to have_content 'Quantidade máxima de pessoas: 40'
    expect(page).to have_content 'Duração: 250'
    expect(page).to have_content 'Cardápio: Frutos do Mar'
    expect(page).to have_content 'Bebidas Alcoólicas: Não disponíveis'
    expect(page).to have_content 'Decoração: Não disponível'
    expect(page).to have_content 'Serviço de Estacionamento: Não disponível'
    expect(page).to have_content 'Exclusivo no local: Evento pode ser feito em qualquer outro local adequado'
    expect(page).to have_content 'Preço Base: R$ 5000'
    expect(page).to have_content 'Adicional por Pessoa: R$ 200'
    expect(page).to have_content 'Adicional por Hora Extra: R$ 20'
    expect(page).to have_content 'Preço Base Especial: R$ 6000'
    expect(page).to have_content 'Adicional por Pessoa Especial: R$ 500'
    expect(page).to have_content 'Adicional por Hora Extra Especial: R$ 30'
    expect(page).not_to have_content 'Editar Evento'
    expect(page).not_to have_content 'Excluir Evento'
    expect(page).not_to have_content 'Editar Preço'
  end
end