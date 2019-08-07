##-----------------------------------------------------------------------------
## Log module
##-----------------------------------------------------------------------------
## Task for RnD Soft
## 06.08.2019
## still@itserv.ru
##-----------------------------------------------------------------------------

# The module can write log information to file or console.
# Calculates execution time.
# Puts trace information
# Supports colors output.


# Example
#    module Catlair
#        log = TLog.new
#        log.path="/tmp"
#        log.file="test.log"
#        log.jobBegin.text "Test"
#        log.debug.text("Hello").param("param", "value")
#        log.jobEnd.text("End").space.text("final text")
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
            @colored = true      # color out true or false

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

        # Log type
        LOG_TYPE_INFO = "I"
        LOG_TYPE_WARNING = "W"
        LOG_TYPE_BEGIN = ">"
        LOG_TYPE_END = "<"
        LOG_TYPE_ERROR = "X"
        LOG_TYPE_DEBUG = "#" 
                
        # Escape colors
        ESC_INK_DEFAULT  = "\x1b[0m"
        ESC_INK_BLACK = "\x1b[30m"
        ESC_INK_RED = "\x1b[31m"
        ESC_INK_GREEN = "\x1b[32m"
        ESC_INK_YELLOW = "\x1b[33m"
        ESC_INK_BLUE = "\x1b[34m"
        ESC_INK_MAGENTA = "\x1b[35m"
        ESC_INK_CYAN = "\x1b[36m"
        ESC_INK_WHITE = "\x1b[37m"
        ESC_INK_GREY = "\x1b[90m"

        ## private declaration
        private
        begin
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
                    color ESC_INK_GREY
                    write @traceLine.to_s.ljust(5) + sprintf('%0.3f',delta).rjust(12) + " "

                    case aType
                    when LOG_TYPE_BEGIN
                      color ESC_INK_BLUE
                    when LOG_TYPE_END
                      color ESC_INK_BLUE
                    when LOG_TYPE_ERROR
                      color ESC_INK_RED
                    when LOG_TYPE_INFO
                      color ESC_INK_CYAN
                    when LOG_TYPE_WARNING
                      color ESC_INK_YELLOW
                    when LOG_TYPE_DEBUG
                      color ESC_INK_WHITE
                    end                                  
                    write aType                    
                    write " " + " " * (4 * @depth.count)
                    color ESC_INK_DEFAULT 
#                end

                # Set params for next calls
                @line = true
                @momentLast = @momentCurrent
#               @messageLast = aMessage
                
                return self
            end

    
            def setFileCallback aCallback
              @fileCallback = aCallback
            end


            # End of line
            def lineEnd
              @line = false
              if @traceFile!=""
                color(ESC_INK_GREY)
                write("["+@traceFile+"]")
                color(ESC_INK_DEFAULT)
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

            attr_reader :colored
            attr_writer :colored

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



            def color aColor
              if @colored
                write aColor
              end
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
                        debug.text key.to_s + ": " 
                        color ESC_INK_GREEN
                        write value.to_s 
                        color ESC_INK_DEFAULT
                    end
                    jobEnd.text"End"
                when "Array"
                    #Arra dump
                    jobBegin.text aName + " ("+className+")"
                    aValue.each_with_index do |value,index|
                        debug.text index.to_s + ": " 
                        color ESC_INK_GREEN 
                        write value.to_s
                        color ESC_INK_DEFAULT
                    end
                    jobEnd.text "End"
                else
                    # All another classes
                    write "[" + aName + ":" + className + " = " 
                    color ESC_INK_GREEN 
                    write aValue.to_s 
                    color ESC_INK_DEFAULT
                    write "]"
                end
                return self
            end



            # Write value to log
            def value aCaption, aValue
                write aCaption + " ["
                color ESC_INK_GREEN 
                write aValue.to_s 
                color ESC_INK_DEFAULT
                write "]"
                return self
            end



            # Dump array to log
            def array aCaption, aArray
            end
            


            # Debug messeges
            def debug
              lineBegin LOG_TYPE_DEBUG
              return self
            end



            # Information messeges
            def info
                lineBegin LOG_TYPE_INFO
                return self
            end



            # Warning messeges without loosing data
            def warning
                lineBegin LOG_TYPE_WARNING
                return self
            end



            # Critical errors with loosing data
            def error
              lineBegin LOG_TYPE_ERROR
              return self
            end



            # Job begin
            def jobBegin              
                lineBegin LOG_TYPE_BEGIN
                # Store moment to stack
                @depth.push @momentCurrent
                return self
            end



            # Job end
            def jobEnd

                if @depth.count>0 then job = @depth.pop end
                lineBegin LOG_TYPE_END
                delta = @momentCurrent - job
                
                if delta != 0
                    color(ESC_INK_GREY)
                    write sprintf('%0.3f ms', delta)
                    color(ESC_INK_DEFAULT)
                end
               
                return self
            end
        end           
    end
end