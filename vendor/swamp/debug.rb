##-----------------------------------------------------------------------------
## Log module
##-----------------------------------------------------------------------------
## Task for RnD Soft
## 06.08.2019
## still@itserv.ru
##-----------------------------------------------------------------------------

# The module can write log information to file or console.
# Supports colors output.


# Example
#    module Catlair
#        log = TLog.new
#        log.path="/tmp"
#        log.file="test.log"
#        log.jobBegin "Test"
#        log.debug("Hello").param("param", "value")
#        log.jobEnd("End").space.text("final text")
#        log.param("Array", [1,2,3,4,5])
#        log.close
#    end

       
module Swamp

    class TLog

        ## Debug constructor      
        def initialize
            @file = "log.txt"     # log file name
            @path = "/tmp"        # log file path
            @section = ""         # log file section

            @line = false         # Line was begun
            @messageLast = ""     # Message last
            @momentLast = 0       # Line moment last
            @momentCurrent = 0    # Line moment current
            @depth = []           # array of the moments

            @traceLine = 0;
            @traceFile = "";
            @traceModule = "";
            @fileCallback = nil;
        end


        ## private declaration
        private
        begin
            # Colors ESC          
            @@default = "\x1b[0m"
            @@red = "\x1b[31m"
            @@green = "\x1b[32m"
            @@grey = "\x1b[90m"

            # New line begin
            def lineBegin aType
                @momentCurrent = Time.new.to_f * 1000

                # Trace information
                trace = caller[1].to_s.split(":");
                @traceFile = trace[0];
                @traceLine = trace[1];
                @traceModule = trace[2];
                
#                if aMessage == @messageLast
#                    # Message is repeated and it will be skip
#                    write "*"
#                else
                    # Close line if it was opened
                    if @line then lineEnd end

                    # calculate worktime
                    if @momentLast == 0
                        delta = 0
                    else
                        delta = @momentCurrent - @momentLast
                    end
                                    
                    # write result to log
                    write @@grey + @traceLine.to_s.ljust(5) + sprintf('%0.3f',delta).rjust(12) + @@default 
                    write " "+aType+" " + " " * (4 * @depth.count)
#                end

                # Set params for next calls
                @line = true
                @momentLast = @momentCurrent
#                @messageLast = aMessage
                
                return self
            end

    
            def setFileCallback aCallback
              @fileCallback = aCallback
            end


            # End of line
            def lineEnd
              @line = false
              if (@traceFile!="")
                write @@grey + " ["+@traceFile+"]" + @@default
              end
              write "\n"               
              return self
            end



            # Internal write to console or log file
            def write aMessage
              if @file==""
                # Console
                print aMessage
              else
              
                begin
                  # Write to file

                  # path create for log
                  if !File.exist? @path
                    FileUtils.mkdir_p @path
                  end

                  # if path exists write file
                  if File.exist? @path 
                    fullPathNameFile = @path + "/" + @section + '_' + @file
                    handle = File.open fullPathNameFile, "a"
                    handle.write aMessage
                    handle.close
                  end
                  
                rescue  
                  # Emergency out
                  print aMessage
                end
              end

              return self
            end          
        end


        
        ## public declaration    
        public
        begin
            # property
            attr_reader :file
            attr_writer :file

            attr_reader :path
            attr_writer :path


            # Open log
            def open
                write "\n"+"Open log"+"\n"
                return self
            end

            # Close log
            def close
                write "\n"+"Close log"+"\n"
                return self
            end



            # Simple text messeges
            def text aMessage
                write aMessage
            end



            # Write space to log
            def space
                write " "
                return self
            end



            # Write param to log
            # aName:string - name of param 
            # aValue:all - value of param
            def param aName, aValue
                className = aValue.class.to_s
                case className
                when "Hash"
                    #Hash dump
                    jobBegin.text aName + " ("+className+")"
                    aValue.each do |key, value|
                        debug.text key.to_s + ": " + @@green + value.to_s + @@default
                    end
                    jobEnd.text"End"
                when "Array"
                    #Arra dump
                    jobBegin.text aName + " ("+className+")"
                    aValue.each_with_index do |value,index|
                        debug.text index.to_s + ": " + @@green + value.to_s + @@default
                    end
                    jobEnd.text "End"
                else
                    # All another classes
                    write "[" + aName + ":" + className + " = " + @@green + aValue.to_s + @@default + "]"
                end
                return self
            end



            # Write param to log
            def value aName, aValue
                write aName + " [" + @@green + aValue.to_s + @@default + "]"
                return self
            end



            # Dump array to log
            def array aCaption, aArray
            end
            


            # Debug messeges
            def debug
                lineBegin @@grey+"#"+@@default
                return self
            end



            # Information messeges
            def info
                lineBegin @@green+"i"+@@default
                return self
            end



            # Warning messeges without loosing data
            def warning
                lineBegin "!"
                return self
            end



            # Critical errors with loosing data
            def error
                lineBegin @@red+"X"+@@default
                return self
            end



            # Job begin
            def jobBegin              
                lineBegin ">"
                # Store moment to stack
                @depth.push @momentCurrent
                return self
            end



            # Job end
            def jobEnd

                if @depth.count>0 then job = @depth.pop end
                lineBegin "<"
                delta = @momentCurrent - job
                
                if delta != 0
                    write sprintf('%0.3f ms', delta)
                end
               
                return self
            end
        end           
    end
end