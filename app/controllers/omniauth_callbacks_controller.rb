class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all 
    raise request.env["omniauth.auth"].to_yaml
  end
  alias_method :twitter, :all
  alias_method :githhub, :all
  alias_method :facebook, :all
  alias_method :linkedin, :all
  alias_method :yahoo, :all 
end
