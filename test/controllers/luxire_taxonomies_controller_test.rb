require 'test_helper'

class LuxireTaxonomiesControllerTest < ActionController::TestCase
  setup do
    @luxire_taxonomy = luxire_taxonomies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:luxire_taxonomies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create luxire_taxonomy" do
    assert_difference('LuxireTaxonomy.count') do
      post :create, luxire_taxonomy: { mega_menu_template: @luxire_taxonomy.mega_menu_template, spree_taxonomy_id: @luxire_taxonomy.spree_taxonomy_id }
    end

    assert_redirected_to luxire_taxonomy_path(assigns(:luxire_taxonomy))
  end

  test "should show luxire_taxonomy" do
    get :show, id: @luxire_taxonomy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @luxire_taxonomy
    assert_response :success
  end

  test "should update luxire_taxonomy" do
    patch :update, id: @luxire_taxonomy, luxire_taxonomy: { mega_menu_template: @luxire_taxonomy.mega_menu_template, spree_taxonomy_id: @luxire_taxonomy.spree_taxonomy_id }
    assert_redirected_to luxire_taxonomy_path(assigns(:luxire_taxonomy))
  end

  test "should destroy luxire_taxonomy" do
    assert_difference('LuxireTaxonomy.count', -1) do
      delete :destroy, id: @luxire_taxonomy
    end

    assert_redirected_to luxire_taxonomies_path
  end
end
