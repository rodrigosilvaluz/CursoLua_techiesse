require "bc"
local path = require "ext_libs.path"
require "validation"


local countryNameValidators = {
    vop.neg(validators.containsNumber),
}

local coinSymbolValidators = {
    vop.neg(validators.containsNumber),
    validators.length(3),
}

function cleanCountryName(countryName)
    return clean(
        countryName,
        countryNameValidators,
        trim,
        string.format('O nome do pais %s nao eh valido', countryName)
    )

    --[[ Código antigo para comparação: <<<<<
    if not isValid(countryName, countryNameValidators) then
        print(string.format('O nome do pais %s nao e valido', countryName))
        os.exit(1)
    end

    return trim(countryName)
    ]]

end

function cleanNumber(value, failMsg)
    local cleanedValue = tonumber(value)

    if cleanedValue == nil then
        print(failMsg)
        os.exit(1)
    end
    return cleanedValue
end

local DATE_PATTERN = '(%d%d%d%d)(%d%d)(%d%d)'
local DATE_FORMAT = 'yyyymmdd'

local dateValidators = {
    validators.length(#DATE_FORMAT),
    validators.matchesRegex(DATE_PATTERN)
}

function assertValidDateString(dateStr)
    return assertValid(
        dateStr,
        dateValidators,
        string.format('Formato de data invalido. A data deve ser informada no formato: %s', DATE_FORMAT)
    )
end

function cleanDate(dateStr, failMsg)
    return clean(
        dateStr,
        dateValidators,
        function (val)
            local year, month, day = string.match(dateStr, DATE_PATTERN)
            return os.time{year = year, month = month, day = day}
        end,
        failMsg
    )
end

local commands = {}

function commands.busca(args)
    -- Ler e validar os dados de entrada:
    local countryName = cleanCountryName(args[1])
    local dateStr = assertValidDateString(args[2] or os.date("%Y%m%d"))

    -- Tentar abrir tabela de moedas:
    local inputFileName = path.join(COIN_DIR, genCoinTableFileName(dateStr))
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


-- TODO: [Legibilidade]: Colocar cada seção desta função em sua própria função:
function commands.converter(args)
    -- Leitura e validação de dados
    local amount = cleanNumber(args[1], "'amount' devia ser um numero")

    -- Exemplo de design imperativo <<<<<
    if not isValid(args[2], coinSymbolValidators) then
        print(string.format('O formato do simbolo da moeda de origem nao e valido. Sao esperados tres letras. Ex: EUR, BRL, ...'))
        os.exit(1)
    end
    local srcCoinSymbol = string.upper(args[2])

    -- Exemplo de design declarativo <<<<<
    local destCoinSymbol = clean(
        args[3],
        coinSymbolValidators,
        string.upper,
        'O formato do simbolo da moeda de destino nao e valido. Sao esperados tres letras. Ex: EUR, BRL, ...'
    )

    local dateStr = assertValidDateString(args[4] or os.date("%Y%m%d"))

    -- Tentar abrir o arquivo de cotações
    local inputFileName = path.join(COIN_DIR, genQuotationFileName(dateStr))
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
        print('Moeda de origem nao encontrada. Simbolo: ' .. srcCoinSymbol)
        os.exit(1)
    end
    local destQuotation = quotations[destCoinSymbol]
    if destQuotation == nil and destCoinSymbol ~= REAL_SYMBOL  then
        print('Moeda de destino nao encontrada. Simbolo: ' .. destCoinSymbol)
        os.exit(1)
    end

    -- Realizar a conversão
    local convertedAmount = convert(quotations, amount, srcCoinSymbol, destCoinSymbol)

    -- Exibir o resultado
    print(string.format('%s %s = %s %s', amount, srcCoinSymbol, convertedAmount, destCoinSymbol))
end

return commands
