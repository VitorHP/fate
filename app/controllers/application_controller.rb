class ApplicationController < ActionController::Base
  before_action :set_locale
  before_filter :configure_permitted_parameters, if: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def self.default_url_options options = {}
    options.merge({
      locale: I18n.locale
    })
  end

  protected

  def load_campaign
    @campaign = Campaign.find params[:campaign_id] if params[:campaign_id]
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:sign_in) << :name
  end

  alias_method :devise_current_user, :current_user

  def current_user
    devise_current_user || User.new(name: "guest")
  end

end
