require 'test_helper'

class IntegrationTestTest < ActionDispatch::IntegrationTest
  test "Open main page" do 
    get "/"
    assert_select "h1", "Статьи"
  end
end
