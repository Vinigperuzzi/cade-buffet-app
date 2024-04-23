require "rails_helper"

describe 'Guest visit home page' do
  it 'and sees "Cadê Buffet" Title' do
    visit root_path

    expect(page).to have_content 'Cadê Buffet'
    expect(page).to have_content 'Lista de Buffets'
    expect(page).not_to have_content 'Meu Buffet'
  end
end