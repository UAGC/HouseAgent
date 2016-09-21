require 'test_helper'

class TransactionControllerTest < ActionDispatch::IntegrationTest
  test "should get stx" do
    get transaction_stx_url
    assert_response :success
  end

  test "should get chart" do
    get transaction_chart_url
    assert_response :success
  end

  test "should get news" do
    get transaction_news_url
    assert_response :success
  end

end
