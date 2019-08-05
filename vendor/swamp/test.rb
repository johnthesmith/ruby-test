require '/opt/nginx/app/debug.rb'

module Catlair
    log = TDebug.new

    i=0
    n=50

    log.jobBegin "Start"
    sleep 0.1
    log.jobBegin "Test"
        while i<n
            log.debug("Hello"+i.to_s).param("i", i.to_s)
            i=i+1
        end
    log.jobEnd("End").space.text("asdasdasd")
    log.error("kek");
    log.info("test");
    log.param("Test hash dump", {"ad"=>3, "123124"=>2});
    log.param("Test array dump", [3, 2, 5, 23]);
    log.jobEnd "end"
    log.close
end 