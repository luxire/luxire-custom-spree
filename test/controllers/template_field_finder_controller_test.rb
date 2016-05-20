require 'test_helper'

class TemplateFieldFinderControllerTest < ActionController::TestCase
  test "should get abandoned_checkouts" do
    get :abandoned_checkouts
    assert_response :success
  end

  test "should get contact_customer" do
    get :contact_customer
    assert_response :success
  end

  test "should get customer_account_invite" do
    get :customer_account_invite
    assert_response :success
  end

  test "should get customer_account_welcome" do
    get :customer_account_welcome
    assert_response :success
  end

  test "should get customer_account_password_reset" do
    get :customer_account_password_reset
    assert_response :success
  end

  test "should get draft_order_invoice" do
    get :draft_order_invoice
    assert_response :success
  end

  test "should get fulfilment_request" do
    get :fulfilment_request
    assert_response :success
  end

  test "should get gift_cards_created" do
    get :gift_cards_created
    assert_response :success
  end

  test "should get new_order" do
    get :new_order
    assert_response :success
  end

  test "should get order_cancelled" do
    get :order_cancelled
    assert_response :success
  end

  test "should get order_confirmation" do
    get :order_confirmation
    assert_response :success
  end

  test "should get order_refund" do
    get :order_refund
    assert_response :success
  end

  test "should get shipping_confirmation" do
    get :shipping_confirmation
    assert_response :success
  end

  test "should get shipping_update" do
    get :shipping_update
    assert_response :success
  end

end
