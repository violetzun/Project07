require 'test_helper'

class CommentControllerTest < ActionController::TestCase
  test "should get comment:string" do
    get :comment:string
    assert_response :success
  end

  test "should get user:references" do
    get :user:references
    assert_response :success
  end

  test "should get entry:references" do
    get :entry:references
    assert_response :success
  end

end
