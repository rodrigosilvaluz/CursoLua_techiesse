local validation = require "ext_libs.validation"

local validators = {}

function validators.number(val)
    return {
        {
            isValid = tonumber,
            failMessage = 'O montante deve ser um numero. Encontrado: ' .. val,
        },
    }
end


COIN_SYMBOL_LENGTH = 3
function validators.srcCoinSymbol(val)
    return {
        {
            isValid = validation.hasOnlyLetters,
            failMessage = 'O formato do simbolo da moeda de origem esta errado. Deve conter apenas letras. Encontrado: ' .. val,
        },
        {
            isValid = validation.lengthEquals(COIN_SYMBOL_LENGTH),
            failMessage = string.format(
                'O formato do simbolo da moeda de origem esta errado. Deve ter tamanho %i. Encontrado: %s',
                COIN_SYMBOL_LENGTH,
                val
            )
        },
    }
end


function validators.destCoinSymbol(val)
    return {
        {
            isValid = validation.hasOnlyLetters,
            failMessage = 'O formato do simbolo da moeda de destino esta errado. Deve conter apenas letras. Encontrado: ' .. val,
        },
        {
            isValid = validation.lengthEquals(COIN_SYMBOL_LENGTH),
            failMessage = string.format(
                'O formato do simbolo da moeda de destino esta errado. Deve ter tamanho %i. Encontrado: %s',
                COIN_SYMBOL_LENGTH,
                val
            )
        },
    }
end


function validators.date(val)
    return {
        {
            isValid = validation.lengthEquals(8),
            failMessage = 'A data esta no formato errado',
        },
    }
end


return validators
