require 'test_helper'

class LuxirePropertiesControllerTest < ActionController::TestCase
  setup do
    @luxire_property = luxire_properties(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:luxire_properties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create luxire_property" do
    assert_difference('LuxireProperty.count') do
      post :create, luxire_property: { name: @luxire_property.name, product_type_id: @luxire_property.product_type_id, value: @luxire_property.value }
    end

    assert_redirected_to luxire_property_path(assigns(:luxire_property))
  end

  test "should show luxire_property" do
    get :show, id: @luxire_property
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @luxire_property
    assert_response :success
  end

  test "should update luxire_property" do
    patch :update, id: @luxire_property, luxire_property: { name: @luxire_property.name, product_type_id: @luxire_property.product_type_id, value: @luxire_property.value }
    assert_redirected_to luxire_property_path(assigns(:luxire_property))
  end

  test "should destroy luxire_property" do
    assert_difference('LuxireProperty.count', -1) do
      delete :destroy, id: @luxire_property
    end

    assert_redirected_to luxire_properties_path
  end
end
