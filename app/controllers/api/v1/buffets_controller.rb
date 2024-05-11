class Api::V1::BuffetsController < ActionController::API
  
  def index
    term = params[:query]
    buffets = []
    model_buffets= Buffet.where("name LIKE :term",term: "%#{term}%").order(:name)
    model_buffets.each do |b|
      buffets << {name: b.name, id: b.id}
    end
    render status: 200, json: buffets
  end
end