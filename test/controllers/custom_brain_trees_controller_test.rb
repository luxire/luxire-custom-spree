require 'test_helper'

class CustomBrainTreesControllerTest < ActionController::TestCase
  test "should get get_braintree_token" do
    get :get_braintree_token
    assert_response :success
  end

end
