class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, unless: :pages_controller?
  # before_action :configure_permitted_parameters, if: :devise_controller?
  include PublicActivity::StoreController
  before_action :count_unseen_activities


  def after_sign_in_path_for(resource)
    cookies.signed[:user_id] = resource.id
    root_path
  end

  def count_unseen_activities
    @activities_count = PublicActivity::Activity.where(recipient: current_user, seen: false).count
  end

  protected

  def pages_controller?
    # used to avoid authentication on static pages
    controller_name == "pages"  # Brought by the `high_voltage` gem
  end

   def configure_permitted_parameters
    # Defines profile type at user creation => permitted params management => Devise
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password,
                                                            :password_confirmation,
                                                            :category, :entity,
                                                            :provider, :uid, :name, :picture,
                                                           )
                                              }
  end
end
