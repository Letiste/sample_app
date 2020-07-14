require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:aze)
    @other_user = users(:azea)
  end

  test "profile display" do
    get user_path @user
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
    assert_match @user.followers.count.to_s, response.body
    assert_match @user.following.count.to_s, response.body
    assert_select 'a[href=?]', followers_user_path(@user)
    assert_select 'a[href=?]', following_user_path(@user)

    get user_path @other_user
    assert_select 'input[type=submit]', count: 0

    log_in_as @user
    get user_path @other_user
    assert_select 'input[type=submit]', count: 1
  end
end
