require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#valid?' do
    it 'must have a name' do
      event = Event.new(name: '', description: 'Buffets para casamentos', min_qtd: 50, max_qtd:1000,
                        duration: 240, menu: 'Frutos do Mar', drinks: true, decoration: true, valet: true)
      
      result = event.valid?
      result = event.errors.include?(:name)

      expect(result).to be true
      expect(event.errors[:name]).to include('não pode ficar em branco')
    end

    it 'must have a description' do
      event = Event.new(name: 'Casamento', description: '', min_qtd: 50, max_qtd:1000,
                        duration: 240, menu: 'Frutos do Mar', drinks: true, decoration: true, valet: true)
      
      result = event.valid?
      result = event.errors.include?(:description)

      expect(result).to be true
      expect(event.errors[:description]).to include('não pode ficar em branco')
    end

    it 'must have a minimum capacity' do
      event = Event.new(name: 'Casamento', description: 'Buffets para casamentos', min_qtd: nil, max_qtd:1000,
                        duration: 240, menu: 'Frutos do Mar', drinks: true, decoration: true, valet: true)
      
      result = event.valid?
      result = event.errors.include?(:min_qtd)

      expect(result).to be true
      expect(event.errors[:min_qtd]).to include('não pode ficar em branco')
    end

    it 'must have a maximum capacity' do
      event = Event.new(name: 'Casamento', description: 'Buffets para casamentos', min_qtd: 50, max_qtd: nil,
                        duration: 240, menu: 'Frutos do Mar', drinks: true, decoration: true, valet: true)
      
      result = event.valid?
      result = event.errors.include?(:max_qtd)

      expect(result).to be true
      expect(event.errors[:max_qtd]).to include('não pode ficar em branco')
    end

    it 'must have a duration' do
      event = Event.new(name: 'Casamento', description: 'Buffets para casamentos', min_qtd: 50, max_qtd:1000,
                        duration: nil, menu: 'Frutos do Mar', drinks: true, decoration: true, valet: true)
      
      result = event.valid?
      result = event.errors.include?(:duration)

      expect(result).to be true
      expect(event.errors[:duration]).to include('não pode ficar em branco')
    end

    it 'must have a menu' do
      event = Event.new(name: 'Casamento', description: 'Buffets para casamentos', min_qtd: 50, max_qtd:1000,
                        duration: 240, menu: '', drinks: true, decoration: true, valet: true)
      
      result = event.valid?
      result = event.errors.include?(:menu)

      expect(result).to be true
      expect(event.errors[:menu]).to include('não pode ficar em branco')
    end
  end
end
