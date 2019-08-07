##------------------------------------------------------------------------------
## Message
##------------------------------------------------------------------------------
## Task for RnD Soft
## 07.08.2019
## still@itserv.ru
##-----------------------------------------------------------------------------

# This object was done as simple email body for dog.rb

#------------------------------------------------------------------------------
# To do list
#------------------------------------------------------------------------------
# def attachFile
# def exportEml
# def send - change send with eml file

# System include
require 'json'

# Swamp include
require_relative 'debug.rb'


module Swamp

  class TMessage

    # Constructor
    # aLog: Debug.rb\TLog
    def initialize aLog
      @log = aLog
    end



    # Private declaration
    private
    begin
      # Propertyes
      @content = nil
      @log = nil
    end
  


    # Public declaration
    public
    begin

      # Propery
      attr_reader :content



      # Clear message
      def clear
        @content = JSON.parse '{}'
      end



      # Save message to file
      # aFolder - folder for save message for example /tmp
      def save aFolder
        @log.jobBegin.text "Save message"
        
        if isContent

          if !File.exist? aFolder    
            FileUtils.mkdir_p aFolder
            @log.debug.value "Create folder", aFolder
          end

          # if path exists write file
          if File.exist? aFolder
          
            #Generat cotent and file name
            textContent = JSON.generate @content
            filePathName = aFolder + '/' +@content["moment"] +"_" + @content["guid"]  + '.json'
            @log.debug.param "Path", filePathName

            # File is writing
            begin
              file = File.open filePathName, "w"
              textContent = file.write textContent
              file.close
            rescue
              @log.error.text("Error").param("path", filePathName)
            end
          end

        end
        
        @log.jobEnd
        return self
      end



      # Load file
      # aFileName - full file name with path. Example /tmp/mail.json
      def load aFileName
        @log.jobBegin.value "Load file", aFileName

        # File is reading
        file = File.open aFileName
        textContent = file.read
        file.close
              
        # Parsing
        begin
          @content = JSON.parse textContent
        rescue Exception => e
          @log.warning.text "JSON error"
        end

        @log.jobEnd
        return self
      end    



      # Content check loaded
      def isContent
        if @content.nil?
          return false
        else
          return true
        end
      end



      # Export to .eml
      # aFileName:string - File name
      def emlExport aFileName
        # to do
        return this
      end



      # Attach file
      # aFileName:string - File name
      def attachFile
        # to do
        return this
      end



      # Send message
      # Use linux command send over system call
      
      def send
        @log.jobBegin.text "Try send message"
        if isContent

          bodyFileName = "/tmp/"+@content["guid"]
          
          file = File.open bodyFileName, "w"
          textContent = file.write @content["body"]
          file.close

          cmd = 'mail ' + @content["recipient"] + ' -s "' + @content['subject'] + '" < ' + bodyFileName
          @log.debug.value "Send command", cmd
          system(cmd)          

          # Delete temporary file
          File.delete (bodyFileName)
        end
        
        @log.jobEnd
        return self
      end

    end      
      
  end

end