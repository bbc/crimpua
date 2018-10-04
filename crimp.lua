Crimpua = Crimpua or {}

function Crimpua.notation (data)
    if type(data) == "nil"     then return("_") end
    if type(data) == "string"  then return(data .. "S") end
    if type(data) == "number"  then return(data .. "N") end
    if type(data) == "boolean" then return(tostring(data) .. "B") end
    --   if type(data) == "table"   then return(Crimpua.coll(data)) end
end

return Crimpua