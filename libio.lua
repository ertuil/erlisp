local util = require("libutil")

local tm = {}

tm.fopen = function(param)
    if #param == 1 then
        return io.open(param[1])
    else 
        return io.open(param[1],param[2])
    end
end

tm.fclose = function(param)
    param[1]:close()
end

tm.tmpfile = function(param)
    return io.tmpfile()
end

tm.flines = function(param)
    local res = {}
    for line in param[1]:lines() do
        res[ #res + 1] = line
    end
    return res
end

tm.fread = function (param)
    if #param == 1 then
        return param[1]:read("*a")
    else
        return param[1]:read(param[2])
    end
end

tm.fwrite = function (...)
    local param = ...
    for ii = 2,#param do
        local tmp = util.pre_fwrite(param[ii])
        param[1]:write(tmp)
    end
    param[1]:flush()
end

tm.fflush = function (param)
    return param[1]:flush()
end

tm.fseek = function (param)
    if #param == 2 then 
        return param[1]:seek(param[2])
    else
        return param[1]:seek(param[2],param[3])
    end
end

tm.finput = function(param)
    return io.input(param[1])
end

tm.foutput = function(param)
    return io.output(param[1])
end

return tm