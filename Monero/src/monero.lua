
require "ext_libs.stringUtils"
require "ext_libs.ioUtils"

require "bc"
require "util"

COIN_DIR = "moedas"


function main(...)
    local args = {...}
    local commandName = args[1]
    if commandName == "busca" then
        local countryName = args[2]
        local day = args[3] or os.date("%Y%m%d")

        local inputFileName = COIN_DIR .. "\\" .. genCoinTableFileName(day)
        local contents = readTextFromFile(inputFileName)
        if contents == nil then
            -- Baixar Arquivo do BC:
            downloadCoinTable(day, COIN_DIR)
            contents = readTextFromFile(inputFileName)
        end
        local coins = readCoins(contents)
        local filteredCoins = filterCoinsByCountry(coins, string.upper(countryName))
        local validCoins = filterValidCoins(filteredCoins)
        local code = validCoins[1].coinCode

        print("Codigo: " .. code .. " - Simbolo: " .. validCoins[1].symbol)


    elseif commandName == "converter" then
        local amount = tonumber(args[2])
        local srcCoinSymbol = string.upper(args[3])
        local destCoinSymbol = string.upper(args[4])
        local dateStr = args[5] --or os.date("%Y%m%d")

        -- Tentar abrir o arquivo de cotações
        local inputFileName = COIN_DIR .. "\\" .. genQuotationFileName(dateStr)
        local contents = readTextFromFile(inputFileName)
        -- Se não existir baixar um novo
        if contents == nil then
            -- Baixar Arquivo do BC:
            downloadQuotationTable(day, COIN_DIR)
            contents = readTextFromFile(inputFileName)
        end

        -- Carregar tabela de cotações
        local quotations = readQuotationTable(contents)

        -- Obter cotações da moeda de origem e da moeda de destino (usar o simbolo)
        local srcQuotation = quotations[srcCoinSymbol]
        if srcQuotation == nil then
            print('Cotacao de origem nao encontrada. Simbolo: ' .. srcCoinSymbol)
            os.exit(1)
        end
        local destQuotation = quotations[destCoinSymbol]
        if destQuotation == nil then
            print('Cotacao de destino nao encontrada. Simbolo: ' .. destCoinSymbol)
            os.exit(1)
        end

        -- Realizar a conversão
        local convertedAmount = convert(amount, srcQuotation, destQuotation)

        -- Exibir o resultado
        print(string.format('%s %s = %s %s', amount, srcQuotation.coinSymbol, convertedAmount, destQuotation.coinSymbol))
    end
end

main(...)


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
