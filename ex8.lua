

a = {10, 20, 30}

table.insert(a, 41)
table.insert(a, 51)

a["count"] = 4
--print(a.count)
a.count = 5
--print(a["count"])

for key, value in pairs(a) do
    --print(key, value)
end


i, v = next(a)
i, v = next(a, i)
i, v = next(a, i)
i, v = next(a, i)
i, v = next(a, i)
i, v = next(a, i)
i, v = next(a, i)
--print(i, v)

--if a[4] == nil then
--    print("O elemento 4 nao existe")
--end





--print("O tamanho da tabela a eh: " .. #a)
--print(table.remove(a))
--print("O tamanho da tabela a eh: " .. #a)




usuario = 
{
    nome = "Joao",
    ["idade do joao"] = 22
}

--print(usuario.nome)
--print(usuario["idade do joao"])


val = {1, 2, 3, 4}


function soma(a, b, c, d)
    return a + b + c + d
end

--print(soma(val[1], val[2]))
print(soma(unpack(val)))


