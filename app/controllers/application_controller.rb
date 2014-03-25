class ApplicationController < ActionController::Base
  before_action :set_locale
  before_filter :authenticate_user!
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

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:sign_in) << :name
  end
end
