require "bc"

local commands = {}

function commands.busca(args)
    local countryName = args[1]
    local day = args[2] or os.date("%Y%m%d")

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
end


function commands.converter(args)
    local amount = tonumber(args[1])
    local srcCoinSymbol = string.upper(args[2])
    local destCoinSymbol = string.upper(args[3])
    local dateStr = args[4] --or os.date("%Y%m%d")

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

return commands
