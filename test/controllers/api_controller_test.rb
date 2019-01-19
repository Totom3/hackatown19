require 'test_helper'

class ApiControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get api_search_url
    assert_response :success
  end

  test "should get create" do
    get api_create_url
    assert_response :success
  end

  test "should get comment" do
    get api_comment_url
    assert_response :success
  end

  test "should get join" do
    get api_join_url
    assert_response :success
  end

  test "should get leave" do
    get api_leave_url
    assert_response :success
  end

end
