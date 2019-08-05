module Swamp
    def loadFile aFileName
        f = File.new aFileName r
        if f
            result = f.read
        else
            result = aFileName
        end;
        return r
    end
    def TestOut
        return "Return from Module Swamp"
    end
end