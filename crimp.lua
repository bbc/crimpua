function notation (data)
   return table.concat(flatten(annotate(data)))
end

function annotate (data)
   if type(data) == "string"  then return(data .. "S") end
   if type(data) == "number"  then return(data .. "N") end
   if type(data) == "boolean" then return(tostring(data) .. "B") end
   if type(data) == "nil"     then return("_") end
   if type(data) == "table"   then return(coll(data)) end
end

function coll (data)
   local out = {}
   if is_array(data) then
      table.sort(out, function (n1, n2)
                    return tostring(n1) < tostring(n2)
                    end)
      for k,v in ipairs(data) do
         table.insert(out, annotate(v))
      end
      table.insert(out, "A")
   else
      table.sort(data, function (n1, n2)
                    return tostring(n1) < tostring(n2)
      end)

      for k,v in pairs(data) do
         local c = { annotate(k), annotate(v) }
         table.sort(c, function (n1, n2)
                       return tostring(n1) < tostring(n2)
                       end)

         table.insert(c, "A")
         table.insert(out, c)
      end
      table.insert(out, "H")
   end

   return out
end


function map(func, tbl)
   local newtbl = {}
   for i,v in pairs(tbl) do
      newtbl[i] = func(v)
   end
   return newtbl
end


function is_array (data)
   if type(data) == "table" then
      if data[1] ~= nil then return true end
   end
end

function flatten(list)
   if type(list) ~= "table" then return {list} end
   local flat_list = {}
   for _, elem in ipairs(list) do
      for _, val in ipairs(flatten(elem)) do
         flat_list[#flat_list + 1] = val
      end
   end
   return flat_list
end


-- print(notation("abc"))
-- print(notation(123))
-- print(notation(true))
-- print(notation(nil))
-- print(notation({ 3, 1, 2 }))
-- print(notation({ a = 1, b = 2 }))
--print(notation({ 3, 1, { 2, 4 }}))

print(notation({a = 1}) == "1NaSAH")
print(notation({1, "a", 3}) == "1N3NaSA")
print(notation({"a", 1, {"b", "2"}}))
print(notation({"a", 1, {"b", "2"}}) == "1N2SbSAaSA")
print(notation({a = {c = 3, d = 2 }}) == "aS3NcSA2NdSAHAH")
