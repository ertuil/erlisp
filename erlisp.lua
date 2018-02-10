#!/usr/local/bin/lua

local _version_ = 0.1
local _author_ = 'Chen Lutong'

local c = require("compiler")
local r = require("interpreter")
local u = require("libutil")
local s = require("libstd")

local help_info = [[
    123
]]

function erlisp()
    local time1,time2
    local opt = _options()
    local ENV = r.createEnv()
    local get_command = c.createParser()

    if opt.file == nil then
        print("This is Erlisp ".. _version_ .. " Copyright (C) 2018, Chen Lutong.")
        print("Currect time: " .. os.date()..",have fun!")
        print()
    end

    if opt.show_time == true then
        time1 = os.clock()
    end

    if opt.show_help == true then
        print(help_info)
    end
    
    if opt.all_load == true then
        r.add_lib(ENV,"libmath")
        r.add_lib(ENV,"libos")
        r.add_lib(ENV,"libstr")
        r.add_lib(ENV,"libtable")
    end

    if opt.pre_run ~= nil then
        local ans,flag = get_command(opt.pre_run)
        if flag == false then
            error("Pre-run script is illegal!")
        else 
            local tmp = c.parser(getToken(ans))
            s.print(r.dolisp(tmp,ENV))
        end
    end

    if opt.file ~= nil then
        run_script(ENV,get_command,opt.file,opt.argv)
    end

    if opt.inter == true or opt.file == nil then
        run_interactive(ENV,get_command)
    end

    if opt.show_time == true then
        time2 = os.clock()
        print("Using "..time2-time1.." second(s).")
    end

end




function _options()
    local opt = {argv = {}}
    local idx = 1
    while idx <= #arg do
        if arg[idx] == "-a" then
            opt.all_load = true
        elseif arg[idx] == "-i" then
            opt.inter = true
        elseif arg[idx] == "-h" then
            opt.show_help = true
        elseif arg[idx] == "-t" then
            opt.show_time = true
        elseif  arg[idx] == "-e" then
            idx = idx + 1
            opt.pre_run = arg[idx]
        else
            opt.file = arg[idx]
            break
        end
        idx = idx + 1
    end

    for ii = idx + 1,#arg do
        opt.argv[#opt.argv + 1] = arg[ii]
    end
    return opt
end

function run_interactive(ENV,get_command)
    while true do
        io.write(">>>")
        local str = io.read()
        local ans,flag = get_command(str)
        while flag == false do
            if ans == "" then break end
            io.write("...\t")
            str = io.read()
            ans,flag = get_command(str)
        end

        local status, ret = xpcall(c.getToken, debug.traceback, ans)
        if status == false then 
            print(ret) 
        end

        local status, ret = xpcall(c.parser, debug.traceback, ret)
        if status == false then print(ret) end

        local status, ret = xpcall(r.dolisp, debug.traceback, ret,ENV)
        if status == false then
            print(ret)
        else 
            s.print(ret)
        end
    end
end

function run_script(ENV,get_command,file,argv)
    ENV.argv = argv
    local ans,flag = get_command(file,true)
    if flag == false then
        error("Compile failed!")
    else 
        local tmp = c.parser(getToken(ans))
        r.dolisp(tmp,ENV)
    end
end


erlisp()