##-----------------------------------------------------------------------------
## Dog application
##-----------------------------------------------------------------------------
## Task for RnD Soft
## 06.08.2019
## still@itserv.ru
##-----------------------------------------------------------------------------

# Main function: send messege
# Start application: ruby [root path]vendor/swamp/dog.rb
# Writing log to: /tmp/dog/log
# Waiting JSON messeges in: /tmp/swamp/dog/outcome


               
# System include
require 'securerandom'

# Swamp include
require_relative 'debug.rb'   # Debugger and tracer
require_relative 'sender.rb'  # Abstract sender
require_relative 'message.rb' # Messege interface


# Main application
module Swamp

  # Start application
  log = TLog.new
  log.path = "/tmp/swamp/dog/log/"
  log.file = "dog.txt"

  # Begin application
  log.open
  log.jobBegin.text("Start MailDog")

  # Path for out folder
  outFolder = "/tmp/swamp/dog/outcome"

  log.info.param "Log file", log.file;
  log.info.param "Out folder", outFolder; 

  # Create Dog object 
  sender = TSender.new log, outFolder

  # Signals are traping
  terminated = false
  Signal.trap("TERM") do
    log.debug.text "Trap TERM"
    terminated = true
  end


  # Signal trapping
  Signal.trap("INT") do
    log.debug.text "Trap INT"
    terminated = true
  end


  # Main loop
  log.jobBegin.text "Main loop"
  while !terminated do
    sender.scan    
    # Loop timeout for saving the processor time
    sleep 2
  end
  log.jobEnd
  
  # Finalize application
  sender.finalize
  
  log.jobEnd.text("End MailDog")
  log.close   
end 