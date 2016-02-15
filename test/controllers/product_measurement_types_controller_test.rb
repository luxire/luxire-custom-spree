require 'test_helper'

class ProductMeasurementTypesControllerTest < ActionController::TestCase
  setup do
    @product_measurement_type = product_measurement_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_measurement_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_measurement_type" do
    assert_difference('ProductMeasurementType.count') do
      post :create, product_measurement_type: { luxire_product_type_id: @product_measurement_type.luxire_product_type_id, measurement_type_id: @product_measurement_type.measurement_type_id }
    end

    assert_redirected_to product_measurement_type_path(assigns(:product_measurement_type))
  end

  test "should show product_measurement_type" do
    get :show, id: @product_measurement_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_measurement_type
    assert_response :success
  end

  test "should update product_measurement_type" do
    patch :update, id: @product_measurement_type, product_measurement_type: { luxire_product_type_id: @product_measurement_type.luxire_product_type_id, measurement_type_id: @product_measurement_type.measurement_type_id }
    assert_redirected_to product_measurement_type_path(assigns(:product_measurement_type))
  end

  test "should destroy product_measurement_type" do
    assert_difference('ProductMeasurementType.count', -1) do
      delete :destroy, id: @product_measurement_type
    end

    assert_redirected_to product_measurement_types_path
  end
end
