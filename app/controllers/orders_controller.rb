class OrdersController < ApplicationController
  before_action :authenticate_customer!, only: [:new, :create, :index]
  before_action :authenticate_user!, only: [:user_index]
  before_action :authenticate_customer_or_user!, only: [:show]

  def index
    @orders = Order.where(customer_id: current_customer.id)
  end

  def user_index
    @pending_orders = Order.where(buffet_id: current_user.id, order_status: :waiting).order(:event_date)
    @general_orders = Order.where(buffet_id: current_user.id).where.not(order_status: :waiting).order(:event_date)
    @buffet = Buffet.find(current_user.buffet_id)
  end

  def show
    @order = Order.find(params[:id])
    if user_signed_in?
      @same_day_orders = Order.where(buffet_id: current_user.id, event_date: @order.event_date)
    end
  end
  
  def new
    @event = Event.find(params[:event_id])
    @order = Order.new
  end

  def create
    @event = Event.find(params[:event_id])
    @order = Order.new(get_params)
    @order.buffet_id = @event.buffet_id
    @order.event_id = @event.id
    @order.order_status = :waiting
    @order.customer_id = current_customer.id

    if @order.save
      message = 'Pedido registrado com sucesso! Aguarde a análise do Buffet.'
      redirect_to @event, notice: message
    else
      flash.now[:alert] = 'Não foi possível registrar o pedido.'
      render :new
    end
  end

  private

  def get_params
    params.require(:order).permit(:event_date, :estimated_qtd,
                                  :event_details, :address, :out_doors)
  end

  def authenticate_customer_or_user!
    if current_customer.present? || current_user.present?
    
    else
      redirect_to new_user_session_path, alert: "Você precisa estar autenticado como dono de buffet ou cliente para ver os detalhes de um pedido."
    end
  end
end