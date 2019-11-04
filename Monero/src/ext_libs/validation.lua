local validation = {}


function validation.validate(val, getValidators)
    local validators = getValidators(val)
    for i, validator in ipairs(validators) do
        if not validator.isValid(val) then
            print(validator.failMessage)
            os.exit(1)
        end
    end
    return val
end


function validation.hasOnlyLetters(val)
    return string.find(val, '^[A-Za-z]+$') ~= nil
end


function validation.lengthEquals(n)
    local validator = function(val)
        return #val == n
    end
    return validator
end


return validation
