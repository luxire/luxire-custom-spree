require 'test_helper'

class LuxireStyleMastersControllerTest < ActionController::TestCase
  setup do
    @luxire_style_master = luxire_style_masters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:luxire_style_masters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create luxire_style_master" do
    assert_difference('LuxireStyleMaster.count') do
      post :create, luxire_style_master: { default_values: @luxire_style_master.default_values, name: @luxire_style_master.name }
    end

    assert_redirected_to luxire_style_master_path(assigns(:luxire_style_master))
  end

  test "should show luxire_style_master" do
    get :show, id: @luxire_style_master
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @luxire_style_master
    assert_response :success
  end

  test "should update luxire_style_master" do
    patch :update, id: @luxire_style_master, luxire_style_master: { default_values: @luxire_style_master.default_values, name: @luxire_style_master.name }
    assert_redirected_to luxire_style_master_path(assigns(:luxire_style_master))
  end

  test "should destroy luxire_style_master" do
    assert_difference('LuxireStyleMaster.count', -1) do
      delete :destroy, id: @luxire_style_master
    end

    assert_redirected_to luxire_style_masters_path
  end
end
