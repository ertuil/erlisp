local tb = {}
local util = require("libutil")

tb["pi"] = math.pi
tb["E"] = 2.7182818284590

tb["abs"] = function(param)
    local param = util.delist(param)
    return util.map(math.abs,param)
end

tb["acos"] =function (param)
    local param = util.delist(param)
    return util.map(math.acos,param)
end

tb["asin"] =function (param)
    local param = util.delist(param)
    return util.map(math.asin,param)
end

tb["atan"] =function (param)
    local param = util.delist(param)
    return util.map(math.atan,param)
end

tb["atan2"] =function (param)
    return math.atan2(param[1],param[2])
end

tb["ceil"] =function (param)
    local param = util.delist(param)
    return util.map(math.ceil,param)
end

tb["cosh"] =function (param)
    local param = util.delist(param)
    return util.map(math.cosh,param)
end

tb["cos"] =function (param)
    local param = util.delist(param)
    return util.map(math.cos,param)
end

tb["deg"] =function (param)
    local param = util.delist(param)
    return util.map(math.deg,param)
end

tb["exp"] =function (param)
    local param = util.delist(param)
    return util.map(math.exp,param)
end

tb["flour"] =function (param)
    local param = util.delist(param)
    return util.map(math.flour,param)
end

tb["mod"] =function (param)
    return math.mod(param[1],param[2])
end

tb["frexp"] =function (param)
    local res1,res2 = math.frexp(param[1])
    return {res1,res2}
end

tb["ldexp"] =function (param)
    return math.ldexp(param[1],param[2])
end

tb["log10"] =function (param)
    local param = util.delist(param)
    return util.map(math.log10,param)
end

tb["log"] =function (param)
    local param = util.delist(param)
    return util.map(math.log,param)
end

tb["modf"] =function (param)
    local param = util.delist(param)
    return util.map(math.modf,param)
end

tb["power"] =function (param)
    return math.power(param[1],param[2])
end

tb["rad"] =function (param)
    local param = util.delist(param)
    return util.map(math.rad,param)
end

tb["sinh"] =function (param)
    local param = util.delist(param)
    return util.map(math.sinh,param)
end

tb["sin"] =function (param)
    local param = util.delist(param)
    return util.map(math.sin,param)
end

tb["tanh"] =function (param)
    local param = util.delist(param)
    return util.map(math.tanh,param)
end

tb["tan"] =function (param)
    local param = util.delist(param)
    return util.map(math.tan,param)
end

tb["sqrt"] =function (param)
    local param = util.delist(param)
    return util.map(math.sqrt,param)
end

tb["randomseed"] =function (param)
    return math.randomseed(param[1])
end

tb["random"] =function (param)
    if #param == 0 then
        return math.random()
    elseif #param == 1 then
        return math.random(param[1])
    elseif #param == 2 then
        return math.random(param[1],param[2])
    elseif #param == 3 then
        local res = {}
        for ii = 0,param[3] do
            res[#res + 1] = math.random(param[1],param[2])
        end
        return res
    end
end

return tb