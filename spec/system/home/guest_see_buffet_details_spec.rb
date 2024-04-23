require "rails_helper"

describe 'Guest sees a details from buffet' do
  it 'and see disponible events' do
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
    event2 = Event.create!(name: 'Formatura', description: 'Serviço de mesa completo para formaturas', min_qtd: 20, max_qtd: 40,
                            duration: 250, menu: 'Canapés', buffet_id: buffet.id)
    price2 = Price.create!(base_price: 3000, sp_base_price:4000, sp_additional_person:200,
                          additional_person:250, sp_extra_hour:10, extra_hour:5, event_id: event2.id)

    visit root_path
    click_on 'Buscar'
    click_on 'Vini'

    expect(page).to have_content 'Casamento'
    expect(page).to have_content 'Serviço de mesa completo para casamentos'
    expect(page).to have_content 'Capacidade Máxima: 40'
    expect(page).to have_content 'Preço Base: R$ 5000,00'
    expect(page).to have_content 'Adicional por Pessoa: R$ 200,00'
    expect(page).to have_content 'Adicional por Hora Extra: R$ 20,00'
    expect(page).to have_content 'Preço Base especial: R$ 6000,00'
    expect(page).to have_content 'Adicional por Pessoa especial: R$ 500,00'
    expect(page).to have_content 'Adicional por Hora Extra especial: R$ 30,00'
    expect(page).to have_content 'Formatura'
    expect(page).to have_content 'Serviço de mesa completo para formaturas'
    expect(page).to have_content 'Capacidade Máxima: 40'
    expect(page).to have_content 'Preço Base: R$ 3000,00'
    expect(page).to have_content 'Adicional por Pessoa: R$ 250,00'
    expect(page).to have_content 'Adicional por Hora Extra: R$ 5,00'
    expect(page).to have_content 'Preço Base especial: R$ 4000,00'
    expect(page).to have_content 'Adicional por Pessoa especial: R$ 200,00'
    expect(page).to have_content 'Adicional por Hora Extra especial: R$ 10,00'
  end
end