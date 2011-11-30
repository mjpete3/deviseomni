class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
  # facebook oauth2 authentication
  def facebook
    if !params[:error]
      @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])
      provide_redirect(@user, "Facebook", "devise.facebook_data")
    else
      redirect_to new_user_registration_url  
    end    
  end
  
  # google oauth2 authentication
  def google_oauth2
    if !params[:error]
      @user = User.find_for_google_oauth(request.env["omniauth.auth"])
      provide_redirect(@user, "Google", "devise.google_data")
    else
      redirect_to new_user_registration_url
    end
  end 
  
  # yahoo oauth2 authentication
  def open_id
    if params[:openid_url] == "http://yahoo.com" 
      @user = User.find_for_yahoo_oauth(request.env["omniauth.auth"]) 
      provide_redirect(@user, "Yahoo", "devise.yahoo_data")
    else
      redirect_to new_user_registration_url      
    end
  end
  
  private
  
  def provide_redirect(authuser, authname, session_name)
      logger.debug request.env["omniauth.auth"].to_yaml
      if authuser.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => authname
        sign_in_and_redirect authuser, :event => :authentication
      else
        session[session_name] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end    
  end
  
end