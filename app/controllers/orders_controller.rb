class OrdersController < ApplicationController
  before_action :authenticate_customer!, only: [:new, :create]

  def index
    @orders = Order.where(customer_id: current_customer.id)
  end

  def show
    @order = Order.find(params[:id])
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
end