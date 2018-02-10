local util = require("libutil")
local checkFinish = util.checkFinish

--[[
    词法分析部分
]]--
function createParser()
    local buff = ""
    function getCommand(command,isfile)
        local isfile = isfile or false
        if isfile == false then
            buff = buff..command
        else
            local file = io.open(command,'r')
            for line in file:lines() do
                buff = buff..string.gsub(line,";.*$","")
            end
        end
        local tmp = checkFinish(buff)
        if tmp == 0 then
            local ans = buff
            buff = ""
            return ans,true
        elseif tmp > 0 then
            return buff,false
        else
            buff = ""
            return buff,false
        end
    end
    return getCommand
end

function getToken(command)
    local command = string.gsub( command,"([%(%)])"," %1 ")
    local command = string.gsub( command,"%% ([%(%)]) ","%1")
    local command = string.gsub( command,"' *(%b())"," ( quote %1 ) ")
    local res = {}
    local idx = 1
    local buff = ""
    while idx <= #command do
        local char = string.sub(command,idx,idx)
        if char == "\"" then
            buff = char
            idx = idx + 1
            char = string.sub(command,idx,idx)
            while char ~= "\"" do
                buff = buff..char
                idx = idx + 1
                char = string.sub(command,idx,idx)
            end
            buff = buff..char
        elseif char~= nil and char ~= " " and char ~= "\t"  and char ~= "\0"then
            buff = buff..char
        else
            if buff ~= "" then res[#res + 1] = buff end
            buff = ""
        end
        idx = idx + 1
    end
    return res
end

--[[
    语法分析部分
]]--
function parser(tokens)  
    local tmp = {}  
    for i = 1, #tokens do  
        tmp[i] = table.remove(tokens)  
    end
    local ans = {"begin"}
    while #tmp > 0 do
        ans[#ans + 1] = yacc(tmp)
    end
    return ans
end  

function yacc(tokens)
    token = table.remove(tokens,#tokens)
    if token == "(" then
        local list = {}
        while tokens[#tokens] ~= ")" do
            list[#list+1] = yacc(tokens)
        end
        table.remove(tokens,#tokens)
        return list
    elseif token == ")" then
        error("Unpected ')'")
    else
        local n = tonumber(token);
        if n then
            return n
        elseif token == "false" then
            return false
        elseif token == "true" then
            return true
        elseif string.sub(token,1,1) == "\"" then
            return {isstring = true,value = string.sub(token,2,#token-1)}
        else
            return token
        end
    end
end


local tm = {}

tm.createParser = createParser
tm.parser = parser
tm.getToken = getToken
tm.yacc = yacc

return tm