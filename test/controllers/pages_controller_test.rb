require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get help" do
    get pages_help_url
    assert_response :success
  end

  test "should get dashboard" do
    get pages_dashboard_url
    assert_response :success
  end
end
