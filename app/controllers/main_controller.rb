class MainController < ApplicationController
  before_filter :authenticate_user!, :except => :index
  
  def index
  end

  def auth
  end

end
