require 'test_helper'

class InformationControllerTest < ActionDispatch::IntegrationTest
  test "should get note" do
    get information_note_url
    assert_response :success
  end

end
