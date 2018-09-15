function notation (data)
   return annotate(data)
end

function annotate (data)
   if type(data) == "string"  then return(data .. "S") end
   if type(data) == "number"  then return(data .. "N") end
   if type(data) == "boolean" then return(tostring(data) .. "B") end
   if type(data) == "nil"     then return("_") end
   if array(data)             then return(sort_array(data) .."A") end
   if type(data) == "table"   then return(sort(data) .."H") end
end

function array (data)
   if type(data) == "table" then
      if data[1] ~= nil then return true end
   end
end

function sort (data)
   -- table.sort(data, function (n1, n2)
   --    return tostring(n1) < tostring(n2)
   -- end)

   output = {}
   for k,v in pairs(data) do
      table.insert(output, { annotate(k), annotate(v) })
   end
   return annotate(output)
end

function sort_array (data)
   table.sort(data, function (n1, n2)
     return tostring(n1) < tostring(n2)
   end)

   output = {}
   for k,v in ipairs(data) do
      output[k] = annotate(v)
   end

   return table.concat(output)
end

print(notation("abc"))
print(notation(123))
print(notation(true))
print(notation(nil))
print(notation({ 3, 1, 2 }))
print(notation({ 3, 1, { 2, 4 }}))
print(notation({ a = 1, b = 2 }))
