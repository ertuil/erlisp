local util = require("libutil")

local tm = {}

tm.rep = function(param)
    return string.rep(param[1],param[2])
end

tm.lower = function(param)
    return string.lower( param[1] )
end

tm.upper = function(param)
    return string.upper( param[1] )
end

tm.sub = function(param)
    if #param == 2 then
        return string.sub( param[1] ,param[2])
    else
        return string.sub( param[1] ,param[2],param[3])
    end
end

tm.find = function(param)
    if #param == 2 then
        return string.find( param[1] ,param[2])
    else
        return string.find( param[1] ,param[2],param[3])
    end
end

tm.match = function(param)
    if #param == 2 then
        return string.match( param[1] ,param[2])
    else
        return string.match( param[1] ,param[2],param[3])
    end
end

tm.gsub = function(param)
    if #param == 3 then
        return string.gsub( param[1] ,param[2],param[3])
    else
        return string.gsub( param[1] ,param[2],param[3],param[4])
    end
end

tm.reverse = function(param)
    return string.reverse( param[1])
end



return tm