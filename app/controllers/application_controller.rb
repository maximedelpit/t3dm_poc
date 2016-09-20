class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, unless: :pages_controller?
  # before_action :configure_permitted_parameters, if: :devise_controller?
  include PublicActivity::StoreController
  before_action :count_unseen_activities
  include Pundit

  # Pundit: white-list approach.
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    request.referer ? path = :back : path = after_sign_in_path_for(current_user)
    redirect_to path
  end

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

  private

   def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
