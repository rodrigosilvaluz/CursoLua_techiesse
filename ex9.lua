
--io.write("Digite alguma coisa: ") -- stdout
--a = io.read() -- stdin

--print("!" .. a .. "!")

arq = io.open("teste.txt", "r")
conteudo = arq:read("*a")
arq:close()



arqSaida = io.open("testeSaida.txt", "w")
arqSaida:write("!" .. conteudo .. "!")
arqSaida:close()


print("!" .. conteudo .. "!")


