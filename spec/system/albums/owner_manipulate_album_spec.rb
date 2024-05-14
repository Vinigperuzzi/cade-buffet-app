require "rails_helper"

describe 'User manipulate its own images' do
  it "and can add images to its own events" do
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

    login_as user, scope: :user
    visit root_path
    click_on 'Meu Buffet'
    click_on 'Mostrar Detalhes'
    click_on 'Adicionar Imagens ao Álbum'
    attach_file 'Imagens', Rails.root.join('spec', 'support', 'festa_casamento.jpg')
    click_on 'Salvar Álbum'

    expect(page).to have_selector('img[src*="festa_casamento.jpg"]')
  end

  it "and can add more images to its own events (holding old ones)" do
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
    click_on 'Editar Álbum'
    attach_file 'Imagens', Rails.root.join('spec', 'support', 'festa_casamento2.jpg')
    click_on 'Salvar Álbum'

    expect(page).to have_selector('img[src*="festa_casamento.jpg"]')
    expect(page).to have_selector('img[src*="festa_casamento2.jpg"]')
  end
end