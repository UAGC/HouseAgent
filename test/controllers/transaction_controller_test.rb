require 'test_helper'

class TransactionControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get transaction_home_url
    assert_response :success
  end

end
