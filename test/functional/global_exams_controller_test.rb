require 'test_helper'

class GlobalExamsControllerTest < ActionController::TestCase
  setup do
    @global_exam = global_exams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:global_exams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create global_exam" do
    assert_difference('GlobalExam.count') do
      post :create, global_exam: { name: @global_exam.name, type: @global_exam.type }
    end

    assert_redirected_to global_exam_path(assigns(:global_exam))
  end

  test "should show global_exam" do
    get :show, id: @global_exam
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @global_exam
    assert_response :success
  end

  test "should update global_exam" do
    put :update, id: @global_exam, global_exam: { name: @global_exam.name, type: @global_exam.type }
    assert_redirected_to global_exam_path(assigns(:global_exam))
  end

  test "should destroy global_exam" do
    assert_difference('GlobalExam.count', -1) do
      delete :destroy, id: @global_exam
    end

    assert_redirected_to global_exams_path
  end
end
