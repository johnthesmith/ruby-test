##-----------------------------------------------------------------------------
## Debug module
##-----------------------------------------------------------------------------
## Task for RnD Soft
## 06.08.2019
## still@itserv.ru
##-----------------------------------------------------------------------------

# The module can write log information to file or console.
# Supports colors output.


# Example
#    module Catlair
#        log = TDebug.new
#        log.file="test.log"
#        log.jobBegin "Test"
#        log.debug("Hello").param("param", "value")
#        log.jobEnd("End").space.text("final text")
#        log.param("Array", [1,2,3,4,5])
#        log.close
#    end

       
module Catlair

    class TDebug

        ## Debug constructor      
        def initialize
            @file = ""          # file
            @line = false       # Line was begun
            @messageLast = ""   # Message last
            @momentLast = 0     # Line moment last
            @momentCurrent = 0  # Line moment current
            @depth = []         # array of the moments
            @traceLine = 0;
            @traceFile = "";
            @traceModule = "";
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
            def lineBegin aType, aMessage
                @momentCurrent = Time.new.to_f * 1000

                # Trace information
                trace = caller[caller.count-2].to_s.split(":");
                @traceFile = trace[0];
                @traceLine = trace[1];
                @traceModule = trace[2];
                
                if aMessage == @messageLast
                    # Message is repeated and it will be skip
                    write "*"
                else
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
                    write " "+aType+" " + " " * (4 * @depth.count) + aMessage
                end

                # Set params for next calls
                @line = true
                @momentLast = @momentCurrent
                @messageLast = aMessage
                
                return self
            end



            # End of line
            def lineEnd
                @line = false
                write "\n"               
                return self
            end



            # Internal write to console or log file
            def write aMessage
                if @file==""
                    # Console
                    print aMessage
                else
                    # Log file
                    h = File.new(@file, 'a')
                    if h 
                        h.write aMessage
                        h.close
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

            # Close log
            def close
                write "\n"
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
            def param aName, aValue
                className = aValue.class.to_s
                case className
                when "Hash"
                    #Hash dump
                    jobBegin aName + " ("+className+")"
                    aValue.each do |key, value|
                        debug key.to_s + ": " + @@green + value.to_s + @@default
                    end
                    jobEnd "End"
                when "Array"
                    #Arra dump
                    jobBegin aName + " ("+className+")"
                    aValue.each_with_index do |value,index|
                        debug index.to_s + ": " + @@green + value.to_s + @@default
                    end
                    jobEnd "End"
                else
                    # All another classes
                    write " [" + aName + ":" + className + " = " + @@green + aValue.to_s + @@default + "] "
                end
                return self
            end



            # Dump array to log
            def array aCaption, aArray
            end
            


            # Debug messeges
            def debug aMessage
                lineBegin @@grey+"#"+@@default, aMessage
                return self
            end



            # Information messeges
            def info aMessage
                lineBegin @@green+"i"+@@default, aMessage
                return self
            end



            # Warning messeges without loosing data
            def warning aMessage
                lineBegin "!", aMessage          
                return self
            end



            # Critical errors with loosing data
            def error aMessage
                lineBegin @@red+"X"+@@default, aMessage           
                return self
            end



            # Job begin
            def jobBegin aMessage                          
                lineBegin ">", aMessage
                # Store moment to stack
                @depth.push @momentCurrent
                write  @@grey + " ["+@traceFile+"]" + @@default
                return self
            end



            # Job end
            def jobEnd aMessage

                if @depth.count>0 then job = @depth.pop end
                lineBegin "<", aMessage
                delta = @momentCurrent - job
                
                if delta != 0
                    write sprintf(' %0.3f sec', delta)
                end
               
                return self
            end
        end           
    end
end