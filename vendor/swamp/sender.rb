##-----------------------------------------------------------------------------
## Sender module
##-----------------------------------------------------------------------------
## Task for RnD Soft
## 06.08.2019
## still@itserv.ru
##-----------------------------------------------------------------------------


# This module written for send TMessage over email end other
   

# Sistem includes
require 'fileutils'

# Swamp includes
require_relative 'debug.rb'
require_relative 'message.rb'


module Swamp

  class TSender

    # Constructor
    def initialize aLog, aOutFolder
      # Set variables
      @log=aLog
      @outFolder = aOutFolder
    end



    ## private declaration
    private
    begin
      # internal propertyes
      @log = nil
      @outFolder = nil

      # Check exists and create the folder for outcoming messeges
      def prepareFolder     
        if !File.exist? @outFolder
          FileUtils.mkdir_p @outFolder
          @log.info.value "Create folder", @outFolder;
        end
        return File.exist? @outFolder
      end

    end

    

    ## Public declaration
    public
    begin
      # property
      attr_reader :log
      attr_reader :outFolder
      
      # Scan out folder end send messeges with expared moment
      def scan
        fileMasq = @outFolder

        @log.jobBegin.value "Scan file name", fileMasq

        if (prepareFolder)
          # Scan files      
          Dir.open(@outFolder).each do |fileName|

            #Get file extention
            ext = File.extname(fileName)

            #Check json
            if (ext==".json")

              # Check file moment
              array = fileName.split("#")

              if (array.count>0)
                fileMoment = array[0].to_f
                currentMoment = Time.now.to_f       

                # Check time
                if fileMoment<currentMoment

                  # Message create and it sent 
                  message = TMessage.new @log
                  filePathName = @outFolder + "/" + fileName
                  if message.load(filePathName).isContent
                    message.send
                  end
                  @log.debug.value "Delete file", filePathName
                  File.delete (filePathName)
                end
              end
            end
          end
        end
        
        @log.jobEnd
      end


      def send aMessage
        aMessage.save @outFolder
        return self;
      end

     
      # Finish work with sender
      def finalize
      end

    end
    
  end  

end 