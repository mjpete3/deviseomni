require 'test_helper'

class Users::OmniauthCallbacksControllerTest < ActionController::TestCase
  include Devise::TestHelpers
    
  setup do    
    @user = users(:one)
    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[:facebook] = {
        'provider' => 'facebook',
        'uid' => '123545',
        'info' => {'image' => 'http://image.location'},
        'extra' => {
            'raw_info' => {
                'email' => 'mjpetersen@comcast.net',
                'last_name' => 'Petersen',
                'first_name' => 'Marty',
                'location' => {'name' => 'Lincroft, NJ'},
                'timezone' => "5"  
            }
        }
      }

    OmniAuth.config.mock_auth[:google] = {
        'info' => { 
          'name' => 'Martin Petersen',
          'last_name' => 'Petersen',
          'email' => 'mjpetersen@comcast.net',
          'first_name' => 'Martin'
        },
        'uid' => "103582099030453724636",
        'credentials' => {
          'expires_at' => '1322540698',
          'expires' => 'true',
          'token' => 'ya29.AHES6ZQ9dYBFufA3JTuNWm8bL-StktgB8YPKehkvfNb9MVr-uGUZuw',
          'refresh_token' => '1/6ezXZo4XQ2J_KaLJ5-9fMfhxRpCObBHuC0j8O-kyh78'
        },
        'extra' => { 
          'raw_info' => { 
            'name' => 'Martin Petersen',
            'gender' => 'male',
            'id' => "103582099030453724636",
            'family_name' => 'Petersen',
            'verified_email' => 'true',
            'given_name' => 'Martin',
            'email' => 'mjpetersen@comcast.net' 
          }
        },
        'provider' => 'google_oauth2'
    }

    OmniAuth.config.mock_auth[:yahoo] = {
        'info' => { 
          'name' => 'Martin Petersen',
          'nickname' => 'Martin',
          'email' => 'mpetersen89@ymail.com'
        },
        'uid' => 'https://me.yahoo.com/a/MhqKEsIny.Lds0CxHamq5QjDrQ8gXydLtEUAGJe7PDSelg--',
        'extra' => { 
          'response' => {
            'endpoint' => {       
              'claimed_id' => 'https://me.yahoo.com/a/MhqKEsIny.Lds0CxHamq5QjDrQ8gXydLtEUAGJe7PDSelg--#b47bf',
              'server_url' => 'https://open.login.yahooapis.com/openid/op/auth'
            },
            'identity_url' => 'https://me.yahoo.com/a/MhqKEsIny.Lds0CxHamq5QjDrQ8gXydLtEUAGJe7PDSelg--#b47bf'
          }
        },
        'provider' => ':open_id'
    }

    request.env["devise.mapping"] = Devise.mappings[:user] 
  end
  
  test "facebook callback" do    
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]   
    get :facebook
    assert_response :redirect
    assert_equal flash[:notice], "Successfully authorized from Facebook account."
  end
  
  test "facebook invalid credentials" do
    get :facebook,
        :error_description => "The user denied your request.", 
        :error_reason => "user_denied", 
        :error => "access_denied"
    assert_redirected_to new_user_registration_url    
  end
  
  test "google callback" do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google]   
    get :google_oauth2
    assert_response :redirect
    assert_equal flash[:notice], "Successfully authorized from Google account."
  end
  
  test "google invalid credentials" do
    get :google_oauth2,
        :error_description => "The user denied your request.", 
        :error_reason => "user_denied", 
        :error => "access_denied"
    assert_redirected_to new_user_registration_url    
  end  
  
  test "yahoo callback" do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:yahoo]   
    get :open_id, :openid_url => "http://yahoo.com"
    assert_response :redirect
    assert_equal flash[:notice], "Successfully authorized from Yahoo account."    
  end
  
  test "yahoo invalid credentials" do
    get :open_id,
        :error_description => "The user denied your request.", 
        :error_reason => "user_denied", 
        :error => "access_denied"
    assert_redirected_to new_user_registration_url    
  end    
  
end