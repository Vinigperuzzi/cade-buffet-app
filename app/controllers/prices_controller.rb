class PricesController < ApplicationController
  before_action :authenticate_user!

  def new
    @price = Price.new
    @event = Event.find(params[:event_id])
    message = 'Você não tem permissão para criar preços para eventos de outras contas.'
    return redirect_to root_path, alert: message unless @event.buffet_id == current_user.buffet_id
  end

  def create
    @event = Event.find(params[:event_id])
    @buffet = Buffet.find(current_user.buffet_id)
    return unless @event.buffet_id == current_user.buffet_id
    @price = Price.new(get_params)
    @price.event_id = @event.id
    if @price.save
      redirect_to @event, notice: 'Preço cadastrado com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível registrar o Preço.'
      render :new
    end
  end

  def edit
    @price = Price.find(params[:id])
    @event = Event.find(params[:event_id])
    message = 'Você não tem permissão para editar preços para eventos de outras contas.'
    return redirect_to root_path, alert: message unless @event.buffet_id == current_user.buffet_id
    @buffet = Buffet.find(current_user.buffet_id)
  end

  def update
    @price = Price.find(params[:id])
    @event = Event.find(params[:event_id])
    return unless @event.buffet_id == current_user.buffet_id
    if @price.update(get_params)
      redirect_to @event, notice: 'Preço atualizado com sucesso.'
    else
      @buffet = Buffet.find(current_user.buffet_id)
      flash.now[:alert] = 'Não foi possível atualizar o Preço.'
      render 'edit'
    end
  end

  private

  def get_params
    params.require(:price).permit(:base_price, :additional_person, :extra_hour, :sp_base_price, :sp_additional_person, :sp_extra_hour)
  end
end