require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pages_index_url
    assert_response :success
  end

  test "should post index" do
    # file_csv = fixture_file_upload('files/session_history.csv', 'text/csv')
    post pages_index_url
    assert_response :success
  end

end
