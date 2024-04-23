class BuffetsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index, :search]
  before_action :set_buffet_for_current_user, only: [:my_buffet, :edit, :update]

  def my_buffet
    @events = Event.where(buffet_id: current_user.buffet_id)
  end

  def show
    @buffet = Buffet.find(params[:id])
    if current_user != nil and @buffet.id == current_user.buffet_id
      return redirect_to my_buffet_buffets_path
    end
    @events = Event.where(buffet_id: params[:id])
  end

  def index
    @buffets = Buffet.all
  end

  def new
    unless current_user.buffet_id == nil
      redirect_to root_path, alert: 'Já existe um Buffet cadastrado para esse usuário.'
    end
    @buffet = Buffet.new
  end

  def create
    unless current_user.buffet_id == nil
      redirect_to root_path, alert: 'Já existe um Buffet cadastrado para esse usuário.'
    end
    @buffet = Buffet.new(get_params)
    if @buffet.save
      @user = current_user
      @user.update(buffet_id: @buffet.id)
      redirect_to root_path, notice: 'Buffet registrado com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível registrar o Buffet.'
      render :new
    end
  end

  def edit
  end

  def update
    if @buffet.update(get_params)
      redirect_to my_buffet_buffets_path, notice: 'Buffet atualizado com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível atualizar o Buffet.'
      render 'new'
    end
  end

  def search
    @term = params[:query]
    buffets_by_name_or_city = Buffet.where("name LIKE :term OR city LIKE :term", term: "%#{@term}%").order(:name)
    events_by_name = Event.where("events.name LIKE ?", "%#{@term}%")
    buffets_by_event_name = Buffet.joins(:events).where(events: { name: events_by_name.pluck(:name) }).order(:name).distinct.order(:name)
    @buffets = (buffets_by_event_name | buffets_by_name_or_city)
    @buffets = (@buffets.sort_by { |buffet| buffet.name.downcase })
  end

  private

  def get_params
    params.require(:buffet).permit(:name, :corporate_name, :register_number, :phone, :email, :address, :district, :state, :city, :payment_method, :description)
  end

  def set_buffet_for_current_user
    if current_user.buffet_id == nil
      return redirect_to new_buffet_path, alert: 'Você precisa criar um Buffet para começar a utilizar a plataforma.'
    end
    @buffet = Buffet.find(current_user.buffet_id)
  end
end