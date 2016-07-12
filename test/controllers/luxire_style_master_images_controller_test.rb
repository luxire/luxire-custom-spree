require 'test_helper'

class LuxireStyleMasterImagesControllerTest < ActionController::TestCase
  setup do
    @luxire_style_master_image = luxire_style_master_images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:luxire_style_master_images)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create luxire_style_master_image" do
    assert_difference('LuxireStyleMasterImage.count') do
      post :create, luxire_style_master_image: { alternate_text: @luxire_style_master_image.alternate_text, category: @luxire_style_master_image.category, image: @luxire_style_master_image.image, luxire_style_master_id: @luxire_style_master_image.luxire_style_master_id }
    end

    assert_redirected_to luxire_style_master_image_path(assigns(:luxire_style_master_image))
  end

  test "should show luxire_style_master_image" do
    get :show, id: @luxire_style_master_image
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @luxire_style_master_image
    assert_response :success
  end

  test "should update luxire_style_master_image" do
    patch :update, id: @luxire_style_master_image, luxire_style_master_image: { alternate_text: @luxire_style_master_image.alternate_text, category: @luxire_style_master_image.category, image: @luxire_style_master_image.image, luxire_style_master_id: @luxire_style_master_image.luxire_style_master_id }
    assert_redirected_to luxire_style_master_image_path(assigns(:luxire_style_master_image))
  end

  test "should destroy luxire_style_master_image" do
    assert_difference('LuxireStyleMasterImage.count', -1) do
      delete :destroy, id: @luxire_style_master_image
    end

    assert_redirected_to luxire_style_master_images_path
  end
end
