require 'test_helper'

class RoutesTest < ActionDispatch::IntegrationTest
  test "route test" do
    assert_generates '/pages/index', { controller: 'pages', action: 'index' }
  end

  test "must route to home index" do
    get '/'
    assert_response :success
  end
end
