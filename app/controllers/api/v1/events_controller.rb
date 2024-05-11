class Api::V1::EventsController < ActionController::API
  require "holidays"
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

  def check_date
    return render status: 412, json: {error: "Date required for this operation"} if params[:date].nil?
    return render status: 412, json: {error: "Guest quantity required for this operation"} if params[:guest_qtd].nil?
    
    @event = Event.find_by(id: params[:id])
    return render status: 406, json: {error: "Event not found for this id"} if @event.nil?
    @date = params[:date].to_date
    @guest_qtd = params[:guest_qtd].to_i
    return render status: 412, json: {error: "Guest quantity above max event's capacity"} if @guest_qtd > @event.max_qtd
    same_day_orders = Order.where(
                      buffet_id: @event.buffet_id, event_date: @date
                      ).where(order_status: :confirmed)
    if same_day_orders.any?
      response = {value: 0, availability: false}
      render status: 200, json: response
    else same_day_orders.empty?
      value = calculate_value
      response = {value: value, availability: true}
      render status: 200, json: response
    end
  end

  private

  def calculate_value
    price = Price.find_by(event_id: @event.id)
    aditional_people = 0
    has_plus_people = @event.min_qtd <= @guest_qtd
    aditional_people = @guest_qtd - @event.min_qtd if has_plus_people

    if not_business_day?
      base = price.sp_base_price
      aditional = price.sp_additional_person

      return value = base + (aditional_people * aditional)
    end

    base = price.base_price
    aditional = price.additional_person
    value = base + (aditional_people * aditional)
  end

  def not_business_day?
    day = @date
    !Holidays.on(day, :br).empty? || day.saturday? || day.sunday?
  end
end