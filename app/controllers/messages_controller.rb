class MessagesController < ApplicationController
  def index
    @order = Order.find(params[:order_id])
    @messages = @order.messages
    @buffet = @order.buffet
    @event = @order.event
    @customer = @order.customer
    @message = Message.new
  end
end