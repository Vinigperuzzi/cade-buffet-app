require 'rails_helper'

RSpec.describe Price, type: :model do
  describe '#valid?' do
    it 'must have a base_price' do
      price = Price.new(base_price: nil, additional_person: 20, extra_hour: 500,
                        sp_base_price: 2500, sp_additional_person: 30, sp_extra_hour: 30)

      result = price.valid?
      result = price.errors.include?(:base_price)
    end

    it 'must have a additional_person' do
      price = Price.new(base_price: 2000, additional_person: nil, extra_hour: 500,
                        sp_base_price: 2500, sp_additional_person: 30, sp_extra_hour: 30)

      result = price.valid?
      result = price.errors.include?(:additional_person)
    end

    it 'must have a extra_hour' do
      price = Price.new(base_price: 2000, additional_person: 20, extra_hour: nil,
                        sp_base_price: 2500, sp_additional_person: 30, sp_extra_hour: 30)

      result = price.valid?
      result = price.errors.include?(:extra_hour)
    end

    it 'must have a sp_base_price' do
      price = Price.new(base_price: 2000, additional_person: 20, extra_hour: 500,
                        sp_base_price: nil, sp_additional_person: 30, sp_extra_hour: 30)

      result = price.valid?
      result = price.errors.include?(:sp_base_price)
    end

    it 'must have a sp_additional_person' do
      price = Price.new(base_price: 2000, additional_person: 20, extra_hour: 500,
                        sp_base_price: 2500, sp_additional_person: nil, sp_extra_hour: 30)

      result = price.valid?
      result = price.errors.include?(:sp_additional_person)
    end

    it 'must have a sp_extra_hour' do
      price = Price.new(base_price: 2000, additional_person: 20, extra_hour: 500,
                        sp_base_price: 2500, sp_additional_person: 30, sp_extra_hour: nil)

      result = price.valid?
      result = price.errors.include?(:sp_extra_hour)
    end
  end
end
