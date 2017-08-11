
s1 = "agua"

s2 = 'abacate'

s3 = "I'm ok"

s4 = [[Este e um 'texto' \n \\
com "quebra" de linha]]

s5 = "Este e um 'texto'\ncom \"quebra\" de linha"

s5 = s5 .. s3


-- print("O comprimento eh: " .. tostring(#s1))

function join(sep, words)
    return table.concat(words, sep)
end

--print ("Cachorro " .. "quente")

--print(join(",", {"Agua", "do", "mar"}))


--print("!" .. string.sub(s4, 5, 7) .. "!")


--print(string.lower(s3))



--print(string.match(s2, "(%a)(a%a)", 3))
v = tostring(5000)

v2 = tonumber("5001", 10)
print(v2)



