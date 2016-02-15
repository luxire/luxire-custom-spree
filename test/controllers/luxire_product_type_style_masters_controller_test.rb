require 'test_helper'

class LuxireProductTypeStyleMastersControllerTest < ActionController::TestCase
  setup do
    @luxire_product_type_style_master = luxire_product_type_style_masters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:luxire_product_type_style_masters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create luxire_product_type_style_master" do
    assert_difference('LuxireProductTypeStyleMaster.count') do
      post :create, luxire_product_type_style_master: { luxire_product_type_id: @luxire_product_type_style_master.luxire_product_type_id, luxire_style_master_id: @luxire_product_type_style_master.luxire_style_master_id }
    end

    assert_redirected_to luxire_product_type_style_master_path(assigns(:luxire_product_type_style_master))
  end

  test "should show luxire_product_type_style_master" do
    get :show, id: @luxire_product_type_style_master
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @luxire_product_type_style_master
    assert_response :success
  end

  test "should update luxire_product_type_style_master" do
    patch :update, id: @luxire_product_type_style_master, luxire_product_type_style_master: { luxire_product_type_id: @luxire_product_type_style_master.luxire_product_type_id, luxire_style_master_id: @luxire_product_type_style_master.luxire_style_master_id }
    assert_redirected_to luxire_product_type_style_master_path(assigns(:luxire_product_type_style_master))
  end

  test "should destroy luxire_product_type_style_master" do
    assert_difference('LuxireProductTypeStyleMaster.count', -1) do
      delete :destroy, id: @luxire_product_type_style_master
    end

    assert_redirected_to luxire_product_type_style_masters_path
  end
end
