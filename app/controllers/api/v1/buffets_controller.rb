class Api::V1::BuffetsController < ActionController::API
  
  def index
    term = params[:query]
    buffets = []
    model_buffets= Buffet.where("name LIKE :term",term: "%#{term}%").order(:name).where(active: true)
    model_buffets.each do |b|
      buffets << {name: b.name, id: b.id}
    end
    render status: 200, json: buffets
  end

  def show
    begin
      b = Buffet.find(params[:id])
      raise ActiveRecord::RecordNotFound if b.nil?
      raise ActiveRecord::QueryAborted unless b.active
      
      buffet = {name: b.name, phone: b.phone, email: b.email, address: b.address,
        district: b.district, state: b.state, city: b.city,
        payment_method: b.payment_method,
        description: b.description, rating: get_rate(b)}
      render status: 200, json: buffet

    rescue ActiveRecord::RecordNotFound => e
      render status: 406, json: {error: "Buffet not found for this buffet_id"}
    rescue ActiveRecord::QueryAborted => e
      render status: 406, json: {error: "Buffet inactive"}
    end
  end

  private

  def get_rate(b)
    rates = Rate.where(buffet_id: b.id)
    acc = 0
    rates.each do |rate|
      acc = acc + rate.score
    end
    @rate_value = (acc.to_f/rates.length).round(1) unless rates.length == 0
  end
end