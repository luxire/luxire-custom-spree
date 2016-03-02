require 'test_helper'

class CustomImagesControllerTest < ActionController::TestCase
  setup do
    @custom_image = custom_images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:custom_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create custom_image" do
    assert_difference('CustomImage.count') do
      post :create, custom_image: { source: @custom_image.source }
    end

    assert_redirected_to custom_image_path(assigns(:custom_image))
  end

  test "should show custom_image" do
    get :show, id: @custom_image
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @custom_image
    assert_response :success
  end

  test "should update custom_image" do
    patch :update, id: @custom_image, custom_image: { source: @custom_image.source }
    assert_redirected_to custom_image_path(assigns(:custom_image))
  end

  test "should destroy custom_image" do
    assert_difference('CustomImage.count', -1) do
      delete :destroy, id: @custom_image
    end

    assert_redirected_to custom_images_path
  end
end
