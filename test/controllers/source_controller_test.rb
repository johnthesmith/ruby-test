require 'test_helper'

class SourceControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get source_index_url
    assert_response :success
  end

end
