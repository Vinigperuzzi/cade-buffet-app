class OrdersController < ApplicationController
  require "holidays"
  before_action :authenticate_customer!, only: [:new, :create, :index]
  before_action :authenticate_user!, only: [:user_index, :update]
  before_action :authenticate_customer_or_user!, only: [:show, :confirm, :cancel]

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
    @event = Event.find(@order.event_id)
    message = 'Você não pode ver detalhes de pedidos de outras pessoas.'
    redirect_to root_path, alert: message if customer_signed_in? and @order.customer_id != current_customer.id
    redirect_to root_path, alert: message if user_signed_in? and @order.buffet_id != current_user.buffet_id
    if user_signed_in?
      @same_day_orders = Order.where(buffet_id: current_user.id, event_date: @order.event_date).where.not(order_status: :canceled)
    end
    @value = calculate_value
    @sp_day = not_business_day?
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

  def update
    @order = Order.find(params[:id])
    @event = @order.event
    if @order.update(get_update_params)
      @order.payment_final_date = 3.days.from_now if @order.payment_final_date.nil?
      @order.extra_tax = 0 if @order.extra_tax.nil?
      @order.discount = 0 if @order.discount.nil?
      @order.final_price = calculate_value
      @order.save
      @order.evaluated!
      redirect_to @order
    else
      @same_day_orders = Order.where(buffet_id: current_user.id, event_date: @order.event_date).where.not(order_status: :canceled)
      flash.now[:alert] = 'Não foi possível atualizar o pedido.'
      render :show
    end
  end

  def confirm
    @order = Order.find(params[:id])
    @order.confirmed!
    redirect_to @order
  end

  def cancel
    @order = Order.find(params[:id])
    @order.canceled!
    redirect_to @order
  end

  private

  def calculate_value
    price = Price.find_by(event_id: @order.event_id)
    return redirect_to user_index_orders_path, alert: "Você precisa cadastrar um preço para esse evento poder ser contratado." if price.nil?
    aditional_people = 0
    aditional_people = @order.estimated_qtd - @event.min_qtd if @event.min_qtd <= @order.estimated_qtd

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
    day = @order.event_date
    !Holidays.on(day, :br).empty? || day.saturday? || day.sunday?
  end

  def get_params
    params.require(:order).permit(:event_date, :estimated_qtd,
                                  :event_details, :address, :out_doors)
  end

  def get_update_params
    params.require(:order).permit(:payment_final_date, :extra_tax, :discount, :tax_description, :discount_description, :payment_form)
  end

  def authenticate_customer_or_user!
    if current_customer.present? || current_user.present?
    
    else
      redirect_to new_user_session_path, alert: "Você precisa estar autenticado como dono de buffet ou cliente para ver os detalhes de um pedido."
    end
  end
end