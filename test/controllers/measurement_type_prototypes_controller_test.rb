require 'test_helper'

class MeasurementTypePrototypesControllerTest < ActionController::TestCase
  setup do
    @measurement_type_prototype = measurement_type_prototypes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:measurement_type_prototypes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create measurement_type_prototype" do
    assert_difference('MeasurementTypePrototype.count') do
      post :create, measurement_type_prototype: { name: @measurement_type_prototype.name, value: @measurement_type_prototype.value }
    end

    assert_redirected_to measurement_type_prototype_path(assigns(:measurement_type_prototype))
  end

  test "should show measurement_type_prototype" do
    get :show, id: @measurement_type_prototype
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @measurement_type_prototype
    assert_response :success
  end

  test "should update measurement_type_prototype" do
    patch :update, id: @measurement_type_prototype, measurement_type_prototype: { name: @measurement_type_prototype.name, value: @measurement_type_prototype.value }
    assert_redirected_to measurement_type_prototype_path(assigns(:measurement_type_prototype))
  end

  test "should destroy measurement_type_prototype" do
    assert_difference('MeasurementTypePrototype.count', -1) do
      delete :destroy, id: @measurement_type_prototype
    end

    assert_redirected_to measurement_type_prototypes_path
  end
end
