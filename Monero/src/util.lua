
DIR_SEP = string.sub(package.config, 1, 1)

function mprint(...)
    local args = {...}
    for i = 1, #args do
        args[i] = "!" .. args[i] .. "!"
    end

    print(unpack(args))
end
