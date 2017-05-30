require 'test_helper'

class CustomRefundControllerTest < ActionController::TestCase
  test "should get refund" do
    get :refund
    assert_response :success
  end

end
