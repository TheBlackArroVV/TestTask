require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get pages_index_url
    assert_response :success
  end

  test 'should post index' do
    file = fixture_file_upload('/files/session_history.csv', 'text/csv')
    post pages_index_url, params: { csv_file: file }
    assert_response :success
  end

  test 'should fails' do
    file = fixture_file_upload('/files/Untitled Document 1.txt', 'text/plain')
    post pages_index_url, params: { csv_file: file }
    assert_response :success
  end

  test 'view callback test' do
    get pages_index_url
    assert_select 'title', 'TestTask'
  end
end
