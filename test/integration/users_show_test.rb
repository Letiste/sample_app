require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest

  def setup
    @user_activated = users(:aze)
    @user_not_activated = users(:bob)
  end

  test "should only show activated users" do
    get user_path(@user_activated)
    assert_template 'users/show'
    get user_path(@user_not_activated)
    assert_redirected_to root_url
  end
end
