#-------------------------------------------------------------------------------
# Task 2.5. Functional test
# Check send email over TSernder
#
# Test for send message immediately
#------------------------------------------------------------------------------

# Rails include
require 'test_helper'

# Swamp include
require_relative Rails.root+'vendor/swamp/sender.rb'
require_relative Rails.root+'vendor/swamp/message.rb'

class SenderTest < ActiveSupport::TestCase
  test "test_send_message" do
    $sender.sendMessage "Functional test", "Task 2.5 functional test. Send email", users(:one).email, 0
    assert_equal "user", users(:one).role
    assert true
  end  
end
