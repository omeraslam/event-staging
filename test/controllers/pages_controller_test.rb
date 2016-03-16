require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get terms" do
    get :terms
    assert_response :success
  end
  
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get privacy" do
    get :privacy
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

  test "should get pricing" do
    get :pricing
    assert_response :success
  end
  
  test "should get error404" do
    get :error404
    assert_response :not_found
  end
  
  test "should get features" do
    get :features
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end
  
  test "should get zerofees" do
    get :zerofees
    assert_response :success
  end

  test "should get explore" do
    get :explore
    assert_response :success
  end

end
