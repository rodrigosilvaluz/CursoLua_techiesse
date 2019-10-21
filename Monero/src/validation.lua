
validators = {
    containsNumber = function(val)
        return string.find(val, '%d') ~= nil
    end,

    length = function(n)
        return function(val)
            return #val == n
        end
    end,

    maxLength = function(n)
        return function(val)
            return #val <= n
        end
    end,

    matchesRegex = function(pattern)
        return function(val)
            return string.match(val, pattern) ~= nil
        end
    end,
}


vop = {
    neg = function(validator)
        return function(val)
            return not validator(val)
        end
    end,
}


--##############################################################################
function clean(val, validators, converter, failMsg)
    assertValid(val, validators, failMsg)
    return converter(val)
end


function assertValid(val, validators, failMsg)
    if not isValid(val, validators) then
        print(failMsg)
        os.exit(1)
    end
    return val
end


function isValid(val, validators)
    local ret = true
    for i, validator in ipairs(validators) do
        ret = ret and validator(val)
        if ret == false then
            break
        end
    end
    return ret
end
