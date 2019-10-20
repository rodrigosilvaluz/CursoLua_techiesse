
function mprint(...)
    local args = {...}
    for i = 1, #args do
        args[i] = "!" .. args[i] .. "!"
    end

    print(unpack(args))
end
