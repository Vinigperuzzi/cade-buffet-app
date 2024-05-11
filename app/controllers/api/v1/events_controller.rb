class Api::V1::EventsController < ActionController::API

  def index
    begin
      term = params[:buffet_id]
      raise ActiveRecord::QueryAborted if term.nil?

      buffet = Buffet.find(term)
      raise ActiveRecord::RecordNotFound if buffet.nil?

      model_events = buffet.events
      events = []
      model_events.each do |e|
        events << {name: e.name, description: e.description, id: e.id}
      end

      render status: 200, json: events
    
    rescue ActiveRecord::QueryAborted => e
      render status: 412, json: {error: "Buffet_id required for this operation"}

    rescue ActiveRecord::RecordNotFound => e
      render status: 406, json: {error: "Buffet not found for this buffet_id"}

    end
    
  end
end