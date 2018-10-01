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
      table.sort(data, function (n1, n2) return safe_tostring(n1) < safe_tostring(n2)  end)

      for k,v in ipairs(data) do
         table.insert(out, annotate(v))
      end
      table.insert(out, "A")
   else
      for k,v in spairs(data) do
         local c = { annotate(k), annotate(v) }
         table.sort(c, function (n1, n2) return safe_tostring(n1) < safe_tostring(n2) end)

         table.insert(c, "A")
         table.insert(out, c)
      end
      table.insert(out, "H")
   end

   return out
end


function safe_tostring (data)
   --print(tostring(data))
   if is_array(data) then
      -- return table.concat(flatten(data))
      return tostring(data)
   else
      return tostring(data)
   end
end

function spairs(t, order)
   -- collect the keys
   local keys = {}
   for k in pairs(t) do keys[#keys+1] = k end

   -- if order function given, sort by it by passing the table and keys a, b,
   -- otherwise just sort the keys
   if order then
      table.sort(keys, function(a,b) return order(t, a, b) end)
   else
      table.sort(keys)
   end

   -- return the iterator function
   local i = 0
   return function()
      i = i + 1
      if keys[i] then
         return keys[i], t[keys[i]]
      end
   end
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


luaunit = require('luaunit')

function testString()
   result = notation("abc")
   luaunit.assertEquals( result, "abcS" )
end

function testNumber()
   result = notation(123)
   luaunit.assertEquals( result, "123N" )
end

function testTrueBoolean()
   result = notation(true)
   luaunit.assertEquals( result, "trueB" )
end

function testFalseBoolean()
   result = notation(false)
   luaunit.assertEquals( result, "falseB" )
end

function testNil()
   result = notation(nil)
   luaunit.assertEquals( result, "_" )
end

function testPlainHashTable()
   result = notation({a = 1})
   luaunit.assertEquals( result, "1NaSAH" )
end

function testFlatHashTable()
   result = notation({b = 2, a = 1})
   luaunit.assertEquals( result, "1NaSA2NbSAH" )
end

function testPlainArrayTable()
   result = notation({1, "a", 3})
   luaunit.assertEquals( result, "1N3NaSA" )
end

-- in Ruby:
-- Crimp.annotate(["a", 1, ["b", "2"]])
-- => [[[1, "N"], [[["2", "S"], ["b", "S"]], "A"], ["a", "S"]], "A"]
function testNestedArrayTable()
   result = notation({"a", 1, {"b", "2"}})
   luaunit.assertEquals( result, "1N2SbSAaSA" )
end

function testNestedHashTable()
   result = notation({a = {c = 3, d = 2 }})
   luaunit.assertEquals( result, "aS3NcSA2NdSAHAH" )
end

function testSomeNestedHashTable()
   result = notation({b = 1, a = {c = 3, d = 2 }})
   luaunit.assertEquals( result, "aS3NcSA2NdSAHA1NbSAH" )
end

os.exit( luaunit.LuaUnit.run() )
