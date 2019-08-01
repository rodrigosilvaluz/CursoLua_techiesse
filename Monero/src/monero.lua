
require "ext_libs.stringUtils"
require "ext_libs.ioUtils"

require "util"

local cmd = require "commands"

COIN_DIR = "moedas"

function main(...)
    local args = {...}
    local commandName = args[1]

    args = {select(2, ...)}
    if cmd[commandName] ~= nil then
        cmd[commandName](args)
    else
        print('Comando nao encontrado: ' .. commandName)
        os.exit(1)
    end
end

main(...)

--##############################################################################
require "bc"
function test()
    local quotationContent = readTextFromFile('moedas\\20190726.csv')
    local quotations = readQuotationTable(quotationContent)
    local afn = quotations[1]
    local eur = quotations[48]
    print(showQuotation(afn))
    print()
    print(showQuotation(eur))
    print()
    print(convert(5, afn, eur))
end

--test()
