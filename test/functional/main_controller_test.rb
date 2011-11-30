require 'test_helper'

class MainControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do    
    @user = users(:one)
  end
  
  test "should get index" do
    sign_out @user
    get :index
    assert_response :success
  end
  
  test "should get index logged in" do
    sign_in @user
    get :index
    assert_response :success
  end

  test "should not get auth" do
    sign_out @user
    get :auth
    assert_redirected_to user_session_path    
  end
  
  test "should get auth" do
    sign_in @user
    get :auth
    assert_response :success
  end

end
