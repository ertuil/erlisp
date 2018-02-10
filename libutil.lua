local t = {}

t.delist = function (param)
    if type(param[1]) == "table" then
        local ii,res = 1,{}
        for ii = 1,#param[1] do
            res[#res + 1] = param[1][ii]
        end
        return res
    else
        return param
    end
end

t.map = function (func,list)
    if type(list) ~= "table"then
        return func(list)
    elseif #list == 1 then
        return func(list[1])
    end
    local res = {}
    for ii = 1,#list do
        res[#res + 1] = func(list[ii])
    end
    return res
end


t.checkFinish = function(buff)
    local ans = 0
    for ii = 1,#buff do
        local char = string.sub(buff,ii,ii)
        if char == "(" and string.sub(buff,ii-1,ii-1) ~= "%" then
            ans = ans + 1
        elseif char == ")" and string.sub(buff,ii-1,ii-1) ~= "%"then
            ans = ans - 1
        end
    end
    return ans
end

t._format_string = function(param)
    local param = string.gsub(param,"%%n","\n")
    param = string.gsub(param,"%%t","\t")
    param = string.gsub(param,"%%v","\v")
    param = string.gsub(param,"%%r","\r")
    param = string.gsub(param,"%%b","\b")
    param = string.gsub(param,"%%a","\a")
    return param
end

t.pre_fwrite = function(param)
    if type(param) == "number" then
        return param
    elseif type(param) == "string" then
        return t._format_string(param)
    else
        return tostring(param)
    end
end

t.run_script = function(ENV,file)
    local get_command = c.createParser()
    local ans,flag = get_command(file,true)
    if flag == false then
        error("Compile failed!")
    else 
        local tmp = c.parser(getToken(ans))
        r.dolisp(tmp,ENV)
    end
end

return t