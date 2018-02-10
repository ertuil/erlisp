function createEnv(ENV)
    if ENV then
        local LOCAL_ENV =  {root = ENV}
        local mt = {__index = ENV}
        setmetatable(LOCAL_ENV, mt)
        return LOCAL_ENV
    else 
        local GLOBE_ENV = {_version = 0.1}
        add_lib(GLOBE_ENV,"libstd")
        add_lib(GLOBE_ENV,"libio")    
        return GLOBE_ENV
    end
end

function createENV_(ENV,vars,param)
    local OENV = ENV
    local ENV = createEnv(OENV)
    if #vars < #param then
        error("Excepted more parameters!")
    end
    for ii = 1,#param do
        ENV[vars[ii]] = param[ii]
    end
    for ii = #param + 1,#vars do
        ENV[vars[ii]] = nil
    end
    return ENV
end

function add_lib(ENV,lib_name)
    
    local libstd = require(lib_name)
    for k,v in pairs(libstd) do
        ENV[k] = v
    end
end

--[[
    解释器
]]--
function checkParamNumber(elem,number)
    if #elem < number then 
        error("Excepted "..number.." parameters, "..#elem.." are Given!")
    end
end

function dolisp(elem,ENV)
    local elem_type = type(elem)
    if elem_type == "number" or elem_type == "boolean" then
        return elem
    elseif elem_type == "table" and elem.isstring == true then
        return elem.value
    elseif elem_type == "string" then
        local res =  ENV[elem]
        if res then
            return res
        else 
            return nil
        end
    elseif #elem == 0 then
        return nil
    elseif elem[1] == "if" then
        local NENV = createEnv(ENV)
        if dolisp(elem[2],NENV) then
            return dolisp(elem[3],NENV)
        elseif #elem == 4 then
            return dolisp(elem[4],NENV)
        end
    elseif elem[1] == "quote" then
        checkParamNumber(elem,2)
        return elem[2]
    elseif elem[1] == "begin" then
        for ii = 2,#elem-1 do
            dolisp(elem[ii],ENV)
        end
        return dolisp(elem[#elem],ENV)
    elseif elem[1] == "var" then
        checkParamNumber(elem,3)    
        ENV[elem[2]] = dolisp(elem[3],ENV)
        return ENV[elem[2]]
    elseif elem[1] == "globe" then
        local t = ENV
        while t.root ~= nil do
            t = t.root
        end
        if #elem >= 3 then
            t[elem[2]] = dolisp(elem[3],ENV)
            return t[elem[2]]
        else 
            return t[elem[2]] 
        end
    elseif elem[1] == "require" then
        checkParamNumber(elem,2)
        local statu,res = pcall(add_lib,ENV,elem[2])
        if statu == false then
            local statu,res = pcall(load_lisp,ENV,elem[2])
            return statu
        else
            return true
        end
    elseif elem[1] == "lambda" then
        checkParamNumber(elem,3)
        return {elem[2],elem[3],["isfunction"] = true}
    elseif elem[1] == "while" then
        local NENV = createEnv(ENV)
        checkParamNumber(elem,3)
        while dolisp(elem[2],NENV) do 
            dolisp(elem[3],NENV)
        end
        return nil
    elseif elem[1] == "for" then
        local NENV = createEnv(ENV)
        checkParamNumber(elem,4)
        for _,v in ipairs(dolisp(elem[3],NENV)) do
            NENV[elem[2]] = v
            dolisp(elem[4],NENV)
        end
    elseif elem then
        local func = dolisp(elem[1], ENV)
        local args = {}
        for ii = 2,#elem do
            args[#args + 1] = dolisp(elem[ii],ENV)
        end
        if type(func) == "function" then
            args[-1] = ENV
            return func(args)
        elseif type(func) == "table" and func.isfunction == true then
            local body = func[2]
            return dolisp(body,createENV_(ENV,func[1],args))
        else
            return args[#args]
        end
    end
end

function load_lisp(ENV,file)
    local c = require("compiler")
    local get_command = c.createParser()
    local ans,flag = get_command(file,true)
    if flag == false then
        error("Compile failed!")
    else 
        local tmp = c.parser(getToken(ans))
        dolisp(tmp,ENV)
    end
end

local tm = {}

tm.createEnv = createEnv
tm.createENV_ = createENV_
tm.add_lib = add_lib
tm.checkParamNumber = checkParamNumber
tm.dolisp = dolisp

return tm
