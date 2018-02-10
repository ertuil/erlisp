local util = require("libutil")

local tm = {}

tm.clock = function(param)
    return os.clock()
end

tm.date = function(param)
    if #param == 0 then
        return os.date()
    elseif #param == 1 then
        return os.date(param[1])
    else 
        return os.date(param[1],param[2])
    end
end

tm.time = function(param)
    if #param == 0 then
        return os.time()
    elseif #param >=  1 then
        local param = util.delist(param)
        local s = {"year","month","day","hour","min","sec"}
        local tmp = {}
        for ii = 1,6 do 
            if param[ii] ~= -1 and #param >= ii then
                tmp[s[ii]] = param[ii]
            end
        end
        if #param >= 7 and param[7] > 0 then
            tmp.isdst = true
        else 
            tmp.isdst = false
        end
        return os.time(tmp)
    end
end

tm.difftime = function(param)
    return os.difftime(param[1],param[2])
end

tm.execute = function(param)
    return os.execute(param[1])
end

tm.remove = function(param)
    return os.remove(param[1])
end

tm.rename = function(param)
    return os.rename(param[1],param[2])
end

tm.tmpname = function(param)
    return os.tmpname()
end

tm.exists = function(param)
    local file = io.open(param[1], "rb")
    if file then file:close() end
    return file ~= nil
end

tm.touch  = function(param)
    local isdict = param[2] or false
    local filename = param[1]
    local res = 0
    if isdict then
        res = os.execute("mkdir "..filename)
    else
        res = os.execute("touch "..filename)
    end
    return res
end

return tm