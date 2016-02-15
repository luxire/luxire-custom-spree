require 'test_helper'

class LuxireVendorMastersControllerTest < ActionController::TestCase
  setup do
    @luxire_vendor_master = luxire_vendor_masters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:luxire_vendor_masters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create luxire_vendor_master" do
    assert_difference('LuxireVendorMaster.count') do
      post :create, luxire_vendor_master: { name: @luxire_vendor_master.name }
    end

    assert_redirected_to luxire_vendor_master_path(assigns(:luxire_vendor_master))
  end

  test "should show luxire_vendor_master" do
    get :show, id: @luxire_vendor_master
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @luxire_vendor_master
    assert_response :success
  end

  test "should update luxire_vendor_master" do
    patch :update, id: @luxire_vendor_master, luxire_vendor_master: { name: @luxire_vendor_master.name }
    assert_redirected_to luxire_vendor_master_path(assigns(:luxire_vendor_master))
  end

  test "should destroy luxire_vendor_master" do
    assert_difference('LuxireVendorMaster.count', -1) do
      delete :destroy, id: @luxire_vendor_master
    end

    assert_redirected_to luxire_vendor_masters_path
  end
end
