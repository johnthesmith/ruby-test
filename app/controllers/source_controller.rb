class SourceController < ApplicationController

    def index
        # I have to create external method for load file or have to find him in RoR
        f = File.new "vendor/swamp/debug.rb"
        if f
            @result = f.read
        else
            @result = aFileName
        end;
    end

end
