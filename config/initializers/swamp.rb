#-------------------------------------------------------------------------------
# Swamp
#-------------------------------------------------------------------------------

require_relative Rails.root+'vendor/swamp/debug.rb'  # Debugger and tracer
require_relative Rails.root+'vendor/swamp/sender.rb'
require_relative Rails.root+'vendor/swamp/message.rb'

module Swamp

  # Create log system
  $log = TLog.new
  $log.path = "/tmp/swamp/rails"
  $log.file = "log.txt"  
  
  $log.open
  $log.info.text "Start rails logger"

  # Create mail system
  # Folder with emails /tmp/rails_outcome

  $sender = TSender.new $log, "/tmp/swamp/dog/outcome"
end