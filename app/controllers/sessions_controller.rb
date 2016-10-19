#registrations_controller.rb
class SessionsController < Devise::SessionsController

    if !Rails.env.development?
        force_ssl
    end

    # def after_sign_in_path_for(resource)
    #     if resource.sign_in_count == 1
    #        dashboard_profile_path
    #     else
    #        root_path
    #     end
    # end

end