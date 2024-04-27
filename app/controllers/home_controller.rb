class HomeController < ApplicationController
  before_action :check_user_have_buffet
  def index; end

  def signup; end
  
  private

  def check_user_have_buffet
    return if current_user == nil
    message = 'Você precisa criar um Buffet para começar a utilizar a plataforma.'
    redirect_to new_buffet_path, alert: message if current_user.buffet_id.nil?
  end
end