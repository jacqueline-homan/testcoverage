class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all 
    auth = request.env["omniauth.auth"].to_yaml
    user = User.from_omniauth(auth)
    checkUser = User.find_by_provider_and_uid auth[:provider], auth [:uid]
    if checkUser
      binding.pry
      sign_in_and_redirect user, :notice "Signed in!"
    else
      session["devise.user_attributes"] = user.user_attributes  
      binding.pry
      redirect_to new_user_registration_url
    end

  end
  alias_method :twitter, :all
  alias_method :githhub, :all
  alias_method :facebook, :all
  alias_method :linkedin, :all
  alias_method :yahoo, :all 
end
