require 'test_helper'

class SchoolPdusControllerTest < ActionController::TestCase
  setup do
    @school_pdu = school_pdus(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:school_pdus)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create school_pdu" do
    assert_difference('SchoolPdu.count') do
      post :create, school_pdu: { name: @school_pdu.name, school_id: @school_pdu.school_id }
    end

    assert_redirected_to school_pdu_path(assigns(:school_pdu))
  end

  test "should show school_pdu" do
    get :show, id: @school_pdu
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @school_pdu
    assert_response :success
  end

  test "should update school_pdu" do
    put :update, id: @school_pdu, school_pdu: { name: @school_pdu.name, school_id: @school_pdu.school_id }
    assert_redirected_to school_pdu_path(assigns(:school_pdu))
  end

  test "should destroy school_pdu" do
    assert_difference('SchoolPdu.count', -1) do
      delete :destroy, id: @school_pdu
    end

    assert_redirected_to school_pdus_path
  end
end
