Crimpua = Crimpua or {}

local function map(func, array)
    local newArray = {}
    for index, value in ipairs(array) do
        newArray[index] = func(value)
    end
    return newArray
end

local function isArray(object)
    return type(object) == "table" and object[1] ~= nil
end

local function isHash(object)
    return type(object) == "table" and not isArray(object)
end

local function convertHashToListOfTuples(hash)
    local newArray = {}
    for key, value in pairs(hash) do
        table.insert(newArray, {tostring(key), value})
    end
    return newArray
end

local function stringCompare(a, b)
    if isArray(a) then table.sort(a,stringCompare); a = a[1] end
    if isArray(b) then table.sort(b,stringCompare); b = b[1] end
    if isHash(a) then a = convertHashToListOfTuples(a); table.sort(a,stringCompare); a = a[1] end
    if isHash(b) then b = convertHashToListOfTuples(b); table.sort(b,stringCompare); b = b[1] end
    return tostring(a) < tostring(b)
end

local function notateCollection(data)
    if not isArray(data) then data = convertHashToListOfTuples(data) end
    table.sort(data, stringCompare)
    return map(Crimpua.notation,data)
end

local function collectionTypeSuffix(collection)
    if isArray(collection) then return "A" end
    return "H"
end

function Crimpua.notation (data)
    if type(data) == "nil"     then return("_") end
    if type(data) == "string"  then return(data .. "S") end
    if type(data) == "number"  then return(data .. "N") end
    if type(data) == "boolean" then return(tostring(data) .. "B") end
    if type(data) == "table"   then return(table.concat(notateCollection(data)) .. collectionTypeSuffix(data)) end
end

return Crimpua