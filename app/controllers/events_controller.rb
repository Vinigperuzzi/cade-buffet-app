class EventsController < ApplicationController
  before_action :authenticate_user!, except: :show

  def show
    @event = Event.find(params[:id])
    @buffet = Buffet.find(@event.buffet_id)
    @price = @event.price
    @album = @event.album
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(get_params)
    @event.buffet_id = current_user.buffet_id
    if @event.save
      message = 'Evento cadastrado com sucesso.'
      redirect_to my_buffet_buffets_path, notice: message
    else
      flash.now[:alert] = 'Não foi possível registrar o Evento.'
      render :new
    end
  end

  def edit
    @event = Event.find(params[:id])

    message = 'Você não tem permissão para editar esse evento.'
    return (
      redirect_to my_buffet_buffets_path, alert: message
      ) unless @event.buffet_id == current_user.buffet_id

    @buffet = Buffet.find(current_user.buffet_id)
  end

  def update
    @event = Event.find(params[:id])
    return redirect_to root_path unless @event.buffet_id == current_user.buffet_id
    if @event.update(get_params)
      message = 'Evento atualizado com sucesso.'
      redirect_to my_buffet_buffets_path, notice: message
    else
      @buffet = Buffet.find(current_user.buffet_id)
      flash.now[:alert] = 'Não foi possível atualizar o Evento.'
      render 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    return redirect_to root_path unless @event.buffet_id == current_user.buffet_id
    ActiveRecord::Base.transaction do
      @event.prices.destroy_all
      @event.destroy
    end
    redirect_to my_buffet_buffets_path
  end

  def active
    @event = Event.find(params[:id])
    return redirect_to root_path unless @event.buffet_id == current_user.buffet_id
    @event.active = true
    @event.save
    redirect_to @event
  end

  def inactive
    @event = Event.find(params[:id])
    return redirect_to root_path unless @event.buffet_id == current_user.buffet_id
    @event.active = false
    @event.save
    redirect_to @event
  end

  private

  def get_params
    params.require(:event).permit(:name, :description, :min_qtd, :max_qtd,
                                  :duration, :menu, :drinks, :decoration,
                                  :valet, :only_local)
  end
end