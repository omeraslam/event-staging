#registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController

  def create
    super
    UserMailer.welcome_email(@user).deliver unless @user.invalid?
  end


def after_sign_up_path_for(resource)
    if resource.sign_in_count == 1
       dashboard_index_path(:welcome => 'true')
    else
       root_path
    end
end

end