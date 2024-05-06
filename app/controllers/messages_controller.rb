class MessagesController < ApplicationController
  before_action :authenticate_customer_or_user!, only: [:index, :create, :edit, :update]
  before_action :check_person, only: [:index, :create]
  before_action :check_person_and_sender, only: [:edit, :update]

  def index
    @messages = @order.messages
    @buffet = @order.buffet
    @event = @order.event
    @customer = @order.customer
    @message = Message.new
  end

  def create
    @message = Message.new(get_params)
    if customer_signed_in?
      @message.sender = :customer
    else
      @message.sender = :user
    end
    @message.order_id = @order.id
    @message.customer_read = false
    @message.user_read = false
    @message.customer_read = true if customer_signed_in?
    @message.user_read = true if user_signed_in?
    return redirect_to order_messages_path(@order.id) if @message.save

    message = "Não foi possível enviar a mensagem. Tente novamente mais tarde."
    redirect_to order_messages_path(@order.id), alert: 
  end

  def edit; end

  def update
    @message.update(get_params)
    return redirect_to order_messages_path(@order.id) if @message.save

    message = "Não foi possível editar a mensagem. Tente novamente mais tarde."
    redirect_to order_messages_path(@order.id), alert: message
  end

  private

  def authenticate_customer_or_user!
    if current_customer.present? || current_user.present?
    
    else
      message = "Você precisa estar autenticado como dono de buffet ou cliente para ver os detalhes de um pedido."
      redirect_to new_user_session_path, alert: message
    end
  end

  def get_params
    params.require(:message).permit(:message_text)
  end

  def check_person
    @order = Order.find(params[:order_id])
    if current_user.present? and @order.buffet_id != current_user.buffet_id
      redirect_to root_path, alert: "Você não permissão para acessar esse chat." 
    end

    if current_customer.present? and @order.customer.id != current_customer.id
      redirect_to root_path, alert: "Você não permissão para acessar esse chat."
    end
  end

  def check_person_and_sender
    @message = Message.find(params[:id])
    check_person
    if current_user.present? and @message.customer?
      redirect_to root_path, alert: "Você não permissão para editar essa mensagem." 
    end

    if current_customer.present? and @message.user?
      redirect_to root_path, alert: "Você não permissão para editar essa mensagem." 
    end
  end
end