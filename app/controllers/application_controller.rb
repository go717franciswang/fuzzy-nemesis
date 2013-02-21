class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery

  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # app/controllers/application_controller.rb
  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end
end
