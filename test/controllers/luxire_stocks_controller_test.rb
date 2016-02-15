require 'test_helper'

class LuxireStocksControllerTest < ActionController::TestCase
  setup do
    @luxire_stock = luxire_stocks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:luxire_stocks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create luxire_stock" do
    assert_difference('LuxireStock.count') do
      post :create, luxire_stock: { backorderable: @luxire_stock.backorderable, deleted_at: @luxire_stock.deleted_at, measuring_unit: @luxire_stock.measuring_unit, parent_sku: @luxire_stock.parent_sku, physical_count_on_hands: @luxire_stock.physical_count_on_hands, rack: @luxire_stock.rack, stock_location_id: @luxire_stock.stock_location_id, threshold: @luxire_stock.threshold, virtual_count_on_hands: @luxire_stock.virtual_count_on_hands }
    end

    assert_redirected_to luxire_stock_path(assigns(:luxire_stock))
  end

  test "should show luxire_stock" do
    get :show, id: @luxire_stock
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @luxire_stock
    assert_response :success
  end

  test "should update luxire_stock" do
    patch :update, id: @luxire_stock, luxire_stock: { backorderable: @luxire_stock.backorderable, deleted_at: @luxire_stock.deleted_at, measuring_unit: @luxire_stock.measuring_unit, parent_sku: @luxire_stock.parent_sku, physical_count_on_hands: @luxire_stock.physical_count_on_hands, rack: @luxire_stock.rack, stock_location_id: @luxire_stock.stock_location_id, threshold: @luxire_stock.threshold, virtual_count_on_hands: @luxire_stock.virtual_count_on_hands }
    assert_redirected_to luxire_stock_path(assigns(:luxire_stock))
  end

  test "should destroy luxire_stock" do
    assert_difference('LuxireStock.count', -1) do
      delete :destroy, id: @luxire_stock
    end

    assert_redirected_to luxire_stocks_path
  end
end
