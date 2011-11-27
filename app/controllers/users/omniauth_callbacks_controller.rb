class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  # facebook oauth2 authentication
  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    provide_redirect(@user, "Facebook", "devise.facebook_data")

  end
  
  # google oauth2 authentication
  def google_oauth2
    @user = User.find_for_google_oauth(request.env["omniauth.auth"], current_user)
    provide_redirect(@user, "Google", "devise.google_data")
  end
  
  # yahoo oauth2 authentication
  def open_id
    if params[:openid_url] == "http://yahoo.com" 
      @user = User.find_for_yahoo_oauth(request.env["omniauth.auth"], current_user) 
      provide_redirect(@user, "Yahoo", "devise.yahoo_data")
    end
  end
  
  private
  
  def provide_redirect(user, authname, session_name)
      logger.debug request.env["omniauth.auth"].to_yaml
      if user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => authname
        sign_in_and_redirect user, :event => :authentication
      else
        session[session_name] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end    
  end
  
end