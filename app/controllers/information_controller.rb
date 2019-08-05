class InformationController < ApplicationController

    def note
        f = File.new "storage/ruby.txt"
        if f
            @result = f.read
        else
            @result = aFileName
        end;   
    end

end
