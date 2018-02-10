local util = require("libutil")
local r = require("interpreter")
local s = require("libstd")
local tm = {}

tm.insert = function (param)
    if #param == 2 then
        return table.insert(param[1],param[2])
    else
        return table.insert(param[1],param[2],param[3])
    end
end



tm.remove = function (param)
    if #param == 1 then
        return table.remove(param[1])
    else
        return table.remove(param[1],param[2])
    end
end

tm.sort = function(param)
    if #param == 1 then
        return table.sort(param[1])
    else
        return table.sort(param[1],param[2])
    end
end

tm.map = function(param)
    local ss = #param[2]
    for ii = 3,#param do 
        if #param[ii] < ss then
            ss = #param[ii]
        end
    end
    local res = {}
    for ii = 1,ss do
        local command = {param[1]}
        for jj = 2,#param do
            command[#command + 1] = param[jj][ii]
        end
        res[#res + 1] = r.dolisp(command,param[-1])
    end
    return res
end

tm.reduce = function(param)
    local _func = param[1]
    local ENV = param[-1]
    local tmp = param[2][1]
    for ii = 2,#param[2] do
        tmp = r.dolisp({param[1],tmp,param[2][ii]},ENV)
    end
    return tmp
end

tm.filter = function(param)
    local _func = param[1]
    local ENV = param[-1]
    local res = {}
    for ii = 1,#param[2] do
        if r.dolisp({param[1],param[2][ii]},ENV) == true then
            res[#res + 1] = param[2][ii]
        end
    end
    return res
end

tm.sort = function(param)
    local res = param[1]
    if #param == 1 then
        table.sort( res )
    else
        local _func = param[2]
        local ENV = param[-1]
        local sort_function = function(a,b)
            return r.dolisp({_func,a,b},ENV)
        end
        table.sort( res, sort_function )
    end
    return res
end

tm.part = function(param)
    if type(param[2]) ~= "table" then
        param[2] = {param[2]}
        param[3] = {param[3]}
    end
    assert(#param[2] == #param[3],"Length of parameter and value is not equal.")

    local _func_name = param[1]
    local _func = param[-1][_func_name]
    local _p,_b,len = _func[1],_func[2],#param[2]

    for ii = 1,len do
        for jj = 1,#_p do
            if _p[jj] == param[2][ii] then
                table.remove(_p,jj)
            end
        end
        for jj = 1,#_b do
            if _b[jj] == param[2][ii] then
                local t = param[3][ii]
                if type(t) == "string" then
                    _b[jj] = {value = t,isstring = true}
                else 
                    _b[jj] = param[3][ii]
                end
            end
        end
    end
    return {_p,_b,isfunction = true}
end

return tm