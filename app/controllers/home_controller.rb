class HomeController < ApplicationController
  def index
    @campaigns = current_user.campaigns
  end
end
