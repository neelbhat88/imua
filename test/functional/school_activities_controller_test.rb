require 'test_helper'

class SchoolActivitiesControllerTest < ActionController::TestCase
  setup do
    @school_activity = school_activities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:school_activities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create school_activity" do
    assert_difference('SchoolActivity.count') do
      post :create, school_activity: { name: @school_activity.name, school_id: @school_activity.school_id }
    end

    assert_redirected_to school_activity_path(assigns(:school_activity))
  end

  test "should show school_activity" do
    get :show, id: @school_activity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @school_activity
    assert_response :success
  end

  test "should update school_activity" do
    put :update, id: @school_activity, school_activity: { name: @school_activity.name, school_id: @school_activity.school_id }
    assert_redirected_to school_activity_path(assigns(:school_activity))
  end

  test "should destroy school_activity" do
    assert_difference('SchoolActivity.count', -1) do
      delete :destroy, id: @school_activity
    end

    assert_redirected_to school_activities_path
  end
end
