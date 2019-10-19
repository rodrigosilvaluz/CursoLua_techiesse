require "bc"

local commands = {}

function commands.busca(args)
    local countryName = args[1]
    local dateStr = args[2] or os.date("%Y%m%d")

    -- Tentar abrir tabela de moedas:
    local inputFileName = COIN_DIR .. "\\" .. genCoinTableFileName(dateStr)
    local contents = readTextFromFile(inputFileName)
    if contents == nil then
        -- Baixar Arquivo do BC:
        print('Informacao nao encontrada. Baixando novo arquivo do BC ...')
        local downloadOk, statusCode = pcall(downloadCoinTable, dateStr, COIN_DIR)
        if not downloadOk then
            print('Nao foi possivel baixar o arquivo de moedas. Erro: ' .. statusCode)
            os.exit(1)
        end
        contents = readTextFromFile(inputFileName)
    end

    -- Obter moeda do arquivo de moedas:
    local coins = readCoins(contents)
    local filteredCoins = filterCoins(byCountry(string.upper(countryName)), coins)
    local validCoins = filterCoins(byValidCoin, filteredCoins)
    local code = validCoins[1].coinCode

    -- Exibir o resultado:
    print("Codigo: " .. code .. " - Simbolo: " .. validCoins[1].symbol)
end


function commands.converter(args)
    local amount = tonumber(args[1])
    local srcCoinSymbol = string.upper(args[2])
    local destCoinSymbol = string.upper(args[3])
    local dateStr = args[4] or os.date("%Y%m%d")

    -- Tentar abrir o arquivo de cotações
    local inputFileName = COIN_DIR .. "\\" .. genQuotationFileName(dateStr)
    local contents = readTextFromFile(inputFileName)
    if contents == nil then
        -- Baixar Arquivo do BC:
        print('Informacao nao encontrada. Baixando novo arquivo do BC ...')
        local downloadOk, statusCode = pcall(downloadQuotationTable, dateStr, COIN_DIR)
        if not downloadOk then
            print('Nao foi possivel baixar o arquivo de cotacao. Erro: ' .. statusCode)
            os.exit(1)
        end
        contents = readTextFromFile(inputFileName)
    end

    -- Carregar tabela de cotações
    local quotations = readQuotationTable(contents)

    -- Obter cotações da moeda de origem e da moeda de destino (usar o simbolo)
    local srcQuotation = quotations[srcCoinSymbol]
    if srcQuotation == nil and srcCoinSymbol ~= REAL_SYMBOL then
        print('Cotacao de origem nao encontrada. Simbolo: ' .. srcCoinSymbol)
        os.exit(1)
    end
    local destQuotation = quotations[destCoinSymbol]
    if destQuotation == nil and destCoinSymbol ~= REAL_SYMBOL  then
        print('Cotacao de destino nao encontrada. Simbolo: ' .. destCoinSymbol)
        os.exit(1)
    end

    -- Realizar a conversão
    local convertedAmount = convert(quotations, amount, srcCoinSymbol, destCoinSymbol)

    -- Exibir o resultado
    print(string.format('%s %s = %s %s', amount, srcCoinSymbol, convertedAmount, destCoinSymbol))
end

return commands
