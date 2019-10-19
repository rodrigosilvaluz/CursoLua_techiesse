-- TODO: [Modularização]: Colocar essas constantes em um módilo próprio (config.lua ?)
CURL_EXEC = [[C:\Techiesse\Cursos\Lua\code\Monero\bin\curl-7.65.3-win64-mingw\bin\curl]]
COIN_TABLE_BASE_URL =  [[https://www4.bcb.gov.br/Download/fechamento]]


function genCoinTableFileName(day)
    return "M" .. day .. ".csv"
end


function genQuotationFileName(day)
    return day .. ".csv"
end


function downloadCoinTable(day, destDir)
    local fileName = genCoinTableFileName(day)
    local url = COIN_TABLE_BASE_URL .. '/' .. fileName
    return downloadFile(url, destDir)
end


function downloadQuotationTable(day, destDir)
    local fileName = genQuotationFileName(day)
    local url = COIN_TABLE_BASE_URL .. '/' .. fileName
    return downloadFile(url, destDir)
end


-- TODO: [Modularização]: Esta função é genérica e deve estar em outro módulo (ioUtils.lua ?)
function downloadFile(url, destDir, fileName)
    fileName = fileName or string.match(url, '/([%w\.]+)$')
    local downloadCommand = string.format('%s -f -w \'%%{http_code}\' -o %s\\%s %s 2> nul', CURL_EXEC, destDir, fileName, url)
    local cmdHandle = io.popen(downloadCommand)
    local res = cmdHandle:read('*a')
    local statusCode = tonumber(string.match(res, "'(%d+)'"))
    -- TODO: [Legibilidade] Criar predicado para o teste abaixo:
    if not (statusCode >= 200 and statusCode < 300) then
        error(statusCode, 2)
    end
    return statusCode
end


function toString(tbMoedas)
    local result = ""
    -- TODO: [Boas Práticas Lua]: usar table.concat abaixo:
    for i, coin in ipairs(tbMoedas) do
        result = result .. "Cod coin: " .. (coin.coinCode or "") .. "\n"
        result = result .. "Nome: " .. (coin.name or "") .. "\n"
        result = result .. "Simbolo: " .. (coin.symbol or "") .. "\n"
        result = result .. "Cod Pais: " .. (coin.countryCode or "") .. "\n"
        result = result .. "Pais: " .. (coin.country or "") .. "\n"
        result = result .. "Tipo Moeda: " .. (coin.coinType or "") .. "\n"
        result = result .. "Data Exlusao: " .. (coin.exclusionDate or "") .. "\n"
        result = result .. "\n"
    end
    return result
end


function readCoins(csvContents)
    local lines = split(csvContents, "\r?\n")
    table.remove(lines, 1) -- Removendo linha de cabeçalho

    local coins = {}
    for i, line in ipairs(lines) do

        local coinFields = split(line, ";")
        if coinFields[2] ~= nil then
            local coin =
            {
                coinCode = trim(coinFields[1]),
                name = trim(coinFields[2]),
                symbol = trim(coinFields[3]),
                countryCode = trim(coinFields[4]),
                country = trim(coinFields[5]),
                coinType = trim(coinFields[6]),
                exclusionDate = trim(coinFields[7]),
            }
            table.insert(coins, coin)
        end
    end

    return coins
end


function byCountry(country)
    function by(coin)
        return coin.country == country
    end
    return by
end


function byValidCoin(coin)
    return #coin.exclusionDate == 0
end


function filterCoins(by, coins)
    local ret = {}
    for i, coin in ipairs(coins) do
        if by(coin) then
            table.insert(ret, coin)
        end
    end

    return ret
end


function readQuotationTable(quotationTableContent)
    local quotations = {}
    local lines = split(trim(quotationTableContent), '\n')
    for i, line in ipairs(lines) do
        local quotation = readQuotation(line)
        quotations[quotation.coinSymbol] = quotation
    end
    return quotations
end

function readQuotation(quotationLine)
    -- 26/07/2019;005;A;AFN;0,04720000;0,04732000;79,75000000;79,95000000
    -- Data;Codigo;Tipo;Simbolo;Tx Compra;Tx Venda;P Compra;P Venda
    local fields = split(quotationLine, ';')
    local quotation =
    {
        coinCode = trim(fields[2]),
        coinType = trim(fields[3]),
        coinSymbol = trim(fields[4]),
        buyRate = bcPriceToNumber(trim(fields[5])),
        sellRate = bcPriceToNumber(trim(fields[6])),
        buyParity = bcPriceToNumber(trim(fields[7])),
        sellParity = bcPriceToNumber(trim(fields[8])),
    }
    return quotation
end


function bcPriceToNumber(bcPrice)
    local cleanedPrice = string.gsub(bcPrice, ',', '.')
    return tonumber(cleanedPrice)
    -- return tonumber((string.gsub(bcPrice, ',', '.')))
end


function showQuotation(quotation)
    return table.concat(
        {
            string.format('Moeda: %s (%s)', quotation.coinSymbol ,quotation.coinType),
            string.format('Taxa     => Compra: %s, Venda: %s', quotation.buyRate, quotation.sellRate),
            string.format('Paridade => Compra: %s, Venda: %s', quotation.buyParity, quotation.sellParity),
        },
        '\n'
    )
end

REAL_SYMBOL = 'BRL'
function toDollar(qt, amount, coinSymbol)
    if coinSymbol == REAL_SYMBOL then
        return amount / qt.USD.sellRate
    end

    local srcQuotation= qt[coinSymbol]
    if srcQuotation.coinType == 'A' then
        return amount / srcQuotation.sellParity
    else
        return amount * srcQuotation.sellParity
    end
end


function fromDollar(qt, amount, coinSymbol)
    if coinSymbol == REAL_SYMBOL then
        return amount * qt.USD.sellRate
    end

    local destQuotation = qt[coinSymbol]
    if destQuotation.coinType == 'A' then
        return amount * destQuotation.sellParity
    else
        return amount / destQuotation.sellParity
    end
end


function convert(qt, amount, srcQuotation, destQuotation)
    return fromDollar(qt, toDollar(qt, amount, srcQuotation), destQuotation)
end
