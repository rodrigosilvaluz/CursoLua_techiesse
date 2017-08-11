

vector = {}

vector.create = function(x, y)
    return {x = x, y = y}
end


vector.soma = function(v1, v2)
    res = {}
    res.x = v1.x + v2.x
    res.y = v1.y + v2.y
    return res
end


function vector.print(v)
    print(table.concat({"(", v.x, ", ", v.y, ")"}))
end


v1 = vector.create(1, 2)
v2 = vector.create(10, 20)

vector.print(v1)
vector.print(v2)
vector.print(vector.soma(v1, v2))

