require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:aze)
    @other_user = users(:azea)
  end

  test "should get new" do
    get signup_path
    assert_response :success
    assert_select "title", full_title("Sign Up")
  end

  test "should redirect edit when not logged in" do
    get edit_user_path @user
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as @user
    get edit_user_path @other_user
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as @user
    patch user_path(@other_user), params: { user: { name: @other_user.name,
                                              email: @other_user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert is_logged_in?
    assert_not @other_user.admin?
    get edit_user_path @other_user
    assert_template 'users/edit'
    patch user_path(@other_user), params: { user: {admin: true }}
    @other_user.reload
    assert_not @other_user.admin?

  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path @user
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as @other_user
    assert_no_difference 'User.count' do
      delete user_path @user
    end
    assert_redirected_to root_url
  end

  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
