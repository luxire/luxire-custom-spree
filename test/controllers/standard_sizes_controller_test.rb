require 'test_helper'

class StandardSizesControllerTest < ActionController::TestCase
  setup do
    @standard_size = standard_sizes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:standard_sizes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create standard_size" do
    assert_difference('StandardSize.count') do
      post :create, standard_size: { biceps: @standard_size.biceps, bottom: @standard_size.bottom, chest: @standard_size.chest, fit_type: @standard_size.fit_type, neck: @standard_size.neck, product_type_id: @standard_size.product_type_id, shirt_length: @standard_size.shirt_length, waist: @standard_size.waist, wrist: @standard_size.wrist, yoke: @standard_size.yoke }
    end

    assert_redirected_to standard_size_path(assigns(:standard_size))
  end

  test "should show standard_size" do
    get :show, id: @standard_size
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @standard_size
    assert_response :success
  end

  test "should update standard_size" do
    patch :update, id: @standard_size, standard_size: { biceps: @standard_size.biceps, bottom: @standard_size.bottom, chest: @standard_size.chest, fit_type: @standard_size.fit_type, neck: @standard_size.neck, product_type_id: @standard_size.product_type_id, shirt_length: @standard_size.shirt_length, waist: @standard_size.waist, wrist: @standard_size.wrist, yoke: @standard_size.yoke }
    assert_redirected_to standard_size_path(assigns(:standard_size))
  end

  test "should destroy standard_size" do
    assert_difference('StandardSize.count', -1) do
      delete :destroy, id: @standard_size
    end

    assert_redirected_to standard_sizes_path
  end
end
