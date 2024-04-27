class AlbumsController < ApplicationController
  before_action :authenticate_user!

  def new
    @album = Album.new
    @event = Event.find(params[:event_id])

    message = 'Você não tem permissão paraadicionar fotos em outras contas.'
    return (
      redirect_to root_path, alert: message
      ) unless @event.buffet_id == current_user.buffet_id
  end

  def create
    @album = Album.new(get_params)
    @event = Event.find(params[:event_id])

    return unless @event.buffet_id == current_user.buffet_id

    @album.event_id = @event.id
    if @album.save
      redirect_to @event, notice: 'Álbum cadastrado com sucesso.'
    else
      flash.now[:alert] = 'Não foi possível registrar o Álbum.'
      render :new
    end
  end

  def edit
    @event = Event.find(params[:event_id])

    message = 'Você não tem permissão para editar preços para eventos de outras contas.'
    return (
      redirect_to root_path, alert: message
      ) unless @event.buffet_id == current_user.buffet_id

    @album = Album.find_by(event_id: @event.id)
  end

  def update
    @event = Event.find(params[:event_id])
    @album = Album.find_by(event_id: @event.id)

    return unless @event.buffet_id == current_user.buffet_id
    
    if @album.update(get_params)
      redirect_to @event, notice: 'Preço atualizado com sucesso.'
    else
      @buffet = Buffet.find(current_user.buffet_id)
      flash.now[:alert] = 'Não foi possível atualizar o Preço.'
      render 'edit'
    end
  end

  private

  def get_params
    params.require(:album).permit(images:[])
  end
end