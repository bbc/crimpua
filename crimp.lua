Crimpua = Crimpua or {}

local function map(func, array)
    local new_array = {}
    for i,v in ipairs(array) do
        new_array[i] = func(v)
    end
    return new_array
end

local function stringCompare(a, b)
    return tostring(a) < tostring(b)
end

local function notateCollection(data)
    table.sort(data, stringCompare)
    return map(Crimpua.notation,data)
end

function Crimpua.notation (data)
    if type(data) == "nil"     then return("_") end
    if type(data) == "string"  then return(data .. "S") end
    if type(data) == "number"  then return(data .. "N") end
    if type(data) == "boolean" then return(tostring(data) .. "B") end
    if type(data) == "table"   then return(table.concat(notateCollection(data)) .. "A") end
end

return Crimpua