require 'test_helper'

class LuxireProductTypesControllerTest < ActionController::TestCase
  setup do
    @luxire_product_type = luxire_product_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:luxire_product_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create luxire_product_type" do
    assert_difference('LuxireProductType.count') do
      post :create, luxire_product_type: { description: @luxire_product_type.description, product_type: @luxire_product_type.product_type }
    end

    assert_redirected_to luxire_product_type_path(assigns(:luxire_product_type))
  end

  test "should show luxire_product_type" do
    get :show, id: @luxire_product_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @luxire_product_type
    assert_response :success
  end

  test "should update luxire_product_type" do
    patch :update, id: @luxire_product_type, luxire_product_type: { description: @luxire_product_type.description, product_type: @luxire_product_type.product_type }
    assert_redirected_to luxire_product_type_path(assigns(:luxire_product_type))
  end

  test "should destroy luxire_product_type" do
    assert_difference('LuxireProductType.count', -1) do
      delete :destroy, id: @luxire_product_type
    end

    assert_redirected_to luxire_product_types_path
  end
end
