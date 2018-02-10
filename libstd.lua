local tb = {}
local util = require("libutil")

function lib_add(param)
    local param = util.delist(param)
    if #param == 2 then 
        return param[1] + param[2]
    else 
        local res = 0
        for ii = 1,#param do
            res = res + param[ii]
        end
        return res
    end
end

function lib_mine(param)
    local param = util.delist(param)
    if #param == 2 then 
        return param[1] - param[2]
    else 
        local res = param[1]
        for ii = 2,#param do
            res = res - param[ii]
        end
        return res
    end
end

function lib_multp(param)
    local param = util.delist(param)
    if #param == 2 then 
        return param[1] * param[2]
    else 
        local res = 1
        for ii = 1,#param do
            res = res * param[ii]
        end
        return res
    end
end

function lib_div(param)
    local param = util.delist(param)
    if #param == 2 then 
        return param[1] / param[2]
    else 
        local res = param[1]
        for ii = 2,#param do
            res = res / param[ii]
        end
        return res
    end
end

function lib_mod(param)
    return param[1] % param[2]
end

function lib_pow(param)
    return param[1] ^ param[2]
end

function lib_print(...)
    local param = ...
    if type(param) ~= "table" then
        param = {param}
    end
    if #param == 0 then return end
    local ii = 1
    for ii = 1,#param do
        lib_print_(param[ii])
        io.write("\t")
    end
    io.write("\n")
    io.flush()
end

function lib_le(...)
    local param = ...
    if #param ~= 2 then error("Need tow values.") end
    return param[1] <= param[2]
end

function lib_lt(...)
    local param = ...
    if #param ~= 2 then error("Need tow values.") end
    return param[1] < param[2]
end

function lib_gt(...)
    local param = ...
    if #param ~= 2 then error("Need tow values.") end
    return param[1] > param[2]
end

function lib_ge(...)
    local param = ...
    if #param ~= 2 then error("Need tow values.") end
    return param[1] >= param[2]
end

function lib_eq(...)
    local param = ...
    if #param == 0 then 
        return true
    elseif #param == 2 then 
        return param[1] == param[2]
    else 
        return false
    end
end

function lib_ne(...)
    local param = ...
    if #param == 1 then
        return true
    elseif #param == 2 then 
        return param[1] ~= param[2]
    else 
        return false
    end
end

function lib_and(...)
    local param = ...
    if #param ~= 2 then error("Need tow values.") end
    return param[1] and param[2]
end

function lib_or(...)
    local param = ...
    if #param ~= 2 then error("Need tow values.") end
    return param[1] or param[2]
end

function lib_not(...)
    local param = ...
    if #param ~= 1 then error("Need tow values.") end
    return not param[1]
end

function lib_concat(...)
    local param = ...
    local res = ""
    for _,v in ipairs(param) do
        res = res..v
    end
    return res
end

function lib_car(...)
    local param = ...
    return param[1][1]
end

function lib_cdr(...)
    local param = ...
    local res = {}
    for ii = 2,#param[1] do
        res[#res + 1] = param[1][ii]
    end
    return res
end

function lib_cons(...)
    local param = ...
    if type(param[1]) ~= "table" then
        tmp = {param[1]}
    else
        tmp = param[1]
    end
    for ii = 1,#param[2] do  
        tmp[#tmp + 1] = param[2][ii]
    end
    return tmp
end

function lib_len(param)
    if #param == 1 then
        return #param[1]
    else 
        local res = {}
        for ii = 1,#param do
            res[ii] = #param[ii]
        end
        return res
    end
end

function lib_print_(param)
    local _type = type(param)
    if _type == "table" then
        io.write("(")

        for k,v in pairs(param) do
            lib_print_(v)
            io.write(",")
        end
        io.write(")")
    elseif  _type == "number" then
        io.write(param)
    elseif  _type == "string" then
        io.write(util._format_string(param))
    else
        io.write(tostring(param))
    end
end


function lib_type(param)
    if #param == 1 then
        return lib_type_(param[1])
    else 
        local res = {}
        for ii = 1,#param do
            res[ii] = lib_type_(param[ii])
        end
        return res
    end
end

function lib_max(param)
    local param = util.delist(param)
    local res = param[1]
    for ii = 2,#param do
        if param[ii] > res then
            res = param[ii]
        end
    end
    return res
end

function lib_min(param)
    local param = util.delist(param)
    local res = param[1]
    for ii = 2,#param do
        if param[ii] < res then
            res = param[ii]
        end
    end
    return res
end

function lib_type_(elem)
    local ans = io.type(elem)
    if type(ans) == "string" then
        return ans
    end
    ans = type(elem)
    if not ans then
        return "nil"
    elseif ans == "boolean" or ans == "number" or ans == "string"then
        return ans 
    elseif ans == "function" or (ans == "table" and elem.isfunction == true) then
        return "function"
    else
        return "list"
    end
end

function lib_range(param)
    local _l,_h,_s = param[1],param[2],param[3] or 1
    local res = {}
    for ii = _l,_h,_s do
        res[#res + 1] = ii
    end
    return res
end

function lib_idx(param)
    local tmp = type(param[1])
    if #param == 2 then
        if tmp == "string" then
            return string.sub(param[1],param[2],param[2])
        elseif tmp == "table" then
            return param[1][param[2]]
        else
             return param[1]
        end
    else 
        local res = {}
        for ii = 2,#param do
            if tmp == "string" then
                res[#res + 1] = string.sub(param[1],param[ii],param[ii])
            elseif tmp == "table" then
                res[#res + 1] = param[1][param[ii]]
            end
        end
        return res
    end
end

function lib_input(param)
    return io.read()
end

function lib_inputs(param)
    local tmp = io.read()

    local split = function(str,reps)
        local resultStrList = {}
        string.gsub(str,'[^'..reps..']+',function ( w )
            table.insert(resultStrList,w)
        end)
        return resultStrList
    end

    local res = split(tmp," ")
    return res
end

function lib_dofile(param)
    return dofile(param[1])
end

function lib_exit(param)
    os.exit()
end

function lib_tonumber(param)
    local param = util.delist(param)
    return util.map(tonumber,param)
end

function lib_tostring(param)
    local param = util.delist(param)
    return util.map(tostring,param)
end

function lib_rawprint(...)
    local param = ...
    if #param == 0 then return end
    local ii = 1
    for ii = 1,#param do
        lib_print_(param[ii])
    end
end

function lib_lget(param)
    return param[1][param[2]]
end

function lib_lset(param)
    param[1][param[2]] = param[3]
    return param[3]
end

function lib_isnil(param)
    if #param == 0 or param[1] == nil then
        return true
    else 
        return false
    end
end

function lib_repeat(param)
    local res = {}
    for ii = 1,param[2] do
        res[#res + 1] = param[1]
    end
    return res
end

-- 基本数学运算
tb["+"] = lib_add
tb["-"] = lib_mine
tb["*"] = lib_multp
tb["/"] = lib_div
tb["%"] = lib_mod
tb["^"] = lib_pow
tb["max"] = lib_max
tb["min"] = lib_min


--基本逻辑运算
tb["<"] = lib_lt
tb["<="] = lib_le
tb[">="] = lib_ge
tb[">"] = lib_gt
tb["=="] = lib_eq
tb["equal"] = lib_eq
tb["!="] = lib_ne
tb["and"] = lib_and
tb["or"] = lib_or
tb["not"] = lib_not
tb["isnil"] = lib_isnil

--car,cdr,cons
tb["car"] = lib_car
tb["cdr"] = lib_cdr
tb["cons"] = lib_cons
tb["idx"] = lib_idx
tb["lget"] = lib_lget
tb["lset"] = lib_lset


--基本IO函数
tb["print"] = lib_print
tb["rawprint"] = lib_rawprint
tb["input"] = lib_input
tb["inputs"] = lib_inputs


-- 功能类函数
tb["concat"] = lib_concat
tb["len"] = lib_len
tb["equal"] = lib_eq
tb["type"] = lib_type
tb["range"] = lib_range
tb["repeat"] = lib_repeat
tb["dofile"] = lib_dofile
tb["tonumber"] = lib_tonumber
tb["tostring"] = lib_tostring
tb["quit"] = lib_exit
tb["exit"] = lib_exit



--类型
tb["number"] = "number"
tb["string"] = "string"
tb["function"] = "function"
tb["boolean"] = "boolean"
tb["nil"] = nil
tb["list"] = "list"

return tb
