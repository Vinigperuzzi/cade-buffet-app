require "rails_helper"

describe 'User visit root_page' do
  it 'and does everything as owner' do
    visit root_path

    click_on 'Entrar'
    click_on 'Login como Dono de Buffet'
    click_on 'Criar uma conta'
    fill_in 'E-mail', with: 'vini@email.com'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirme sua senha', with: 'password'
    click_on 'Criar conta'

    fill_in 'Nome', with: 'Vini Buffet'
    fill_in 'Razão Social', with: 'Vini Buffet LTDA'
    fill_in 'CNPJ', with: '12345678000154'
    fill_in 'Telefone', with: '53 991464646'
    fill_in 'E-mail', with: 'vini@email.com'
    fill_in 'Endereço', with: 'Rua das Flores, 600'
    fill_in 'Bairro', with: 'Centro'
    fill_in 'Estado', with: 'RS'
    fill_in 'Cidade', with: 'Pelotas'
    fill_in 'Formas de Pagamento', with: 'Dinheiro'
    fill_in 'Descrição', with: 'Buffet elegante para casamentos'
    click_on 'Salvar Buffet'

    click_on 'Meu Buffet'
    click_on 'Adicionar Evento'

    fill_in 'Nome', with: 'Casamento'
    fill_in 'Descrição', with: 'Buffet de qualidade e elegância'
    fill_in 'Quantidade mínima', with: '50'
    fill_in 'Quantidade máxima', with: '200'
    fill_in 'Duração', with: '520'
    fill_in 'Cardápio', with: 'Frutos do Mar'
    click_on 'Salvar Evento'

    click_on 'Mostrar Detalhes'
    click_on 'Adicionar Preço'
    fill_in 'Preço Base', with: '2000'
    fill_in 'Adicional por Pessoa', with: '200'
    fill_in 'Adicional por Hora Extra', with: '100'
    fill_in 'Preço Base Especial', with: '6000'
    fill_in 'Adicional por Pessoa Especial', with: '250'
    fill_in 'Adicional por Hora Extra Especial', with: '150'
    click_on 'Salvar Preço'

    expect(page).to have_content 'Casamento'
    expect(page).to have_content 'Buffet de qualidade e elegância'
    expect(page).to have_content '50'
    expect(page).to have_content '200'
    expect(page).to have_content '520'
    expect(page).to have_content 'Frutos do Mar'
    expect(page).to have_content 'Bebidas Alcoólicas: Não disponíveis'
    expect(page).to have_content '2000'
    expect(page).to have_content '200'
    expect(page).to have_content '100'
    expect(page).to have_content '6000'
    expect(page).to have_content '250'
    expect(page).to have_content '150'
  end
end