Crimpua = Crimpua or {}

function Crimpua.notation (data)
   return table.concat(flatten(Crimpua.annotate(data)))
end

function Crimpua.annotate (data)
   if type(data) == "string"  then return(data .. "S") end
   if type(data) == "number"  then return(data .. "N") end -- FIXME : make compatible with Lua 5.1
   if type(data) == "boolean" then return(tostring(data) .. "B") end
   if type(data) == "nil"     then return("_") end
   if type(data) == "table"   then return(Crimpua.coll(data)) end
end

function Crimpua.coll (data)
   local out = {}

   table.sort(data, Crimpua.sort)

   if is_array(data) then
      for k,v in ipairs(data) do
         table.insert(out, Crimpua.annotate(v))
      end
      table.insert(out, "A")
   else
      for k,v in spairs(data) do
         local tuple = { Crimpua.annotate(k), Crimpua.annotate(v) }
         table.sort(tuple, Crimpua.sort)
         table.insert(tuple, "A")

         table.insert(out, tuple)
      end
      table.insert(out, "H")
   end

   return out
end

function Crimpua.sort(n1, n2)
   return safe_tostring(n1) < safe_tostring(n2)
end

-- end Crimpua

-- start Generic utils functions
-- TODO namespace as U. or G. ?

function safe_tostring (data)
   -- print(tostring(data))
   if is_array(data) then
      table.sort(data, Crimpua.sort)
      return flatten(data)[1]
   elseif type(data) == "table" then
      print("-------------")
      table_print(data)
      print("-------------")

      table.sort(data, Crimpua.sort)
      return data[1]
   else
      return tostring(data)
   end
end

function table_print (tt, indent, done)
   done = done or {}
   indent = indent or 0
   if type(tt) == "table" then
      for key, value in pairs (tt) do
         io.write(string.rep (" ", indent)) -- indent it
         if type (value) == "table" and not done [value] then
            done [value] = true
            io.write(string.format("[%s] => table\n", tostring (key)));
            io.write(string.rep (" ", indent+4)) -- indent it
            io.write("(\n");
            table_print (value, indent + 7, done)
            io.write(string.rep (" ", indent+4)) -- indent it
            io.write(")\n");
         else
            io.write(string.format("[%s] => %s\n",
                                   tostring (key), tostring(value)))
         end
      end
   else
      io.write(tt .. "\n")
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

--
-- test suite
--

luaunit = require('luaunit')

-- function testString()
--    result = Crimpua.notation("abc")
--    luaunit.assertEquals( result, "abcS" )
-- end

-- function testNumber()
--    result = Crimpua.notation(123)
--    luaunit.assertEquals( result, "123N" )
-- end

-- function testTrueBoolean()
--    result = Crimpua.notation(true)
--    luaunit.assertEquals( result, "trueB" )
-- end

-- function testFalseBoolean()
--    result = Crimpua.notation(false)
--    luaunit.assertEquals( result, "falseB" )
-- end

-- function testNil()
--    result = Crimpua.notation(nil)
--    luaunit.assertEquals( result, "_" )
-- end

-- function testPlainHashTable()
--    result = Crimpua.notation({a = 1})
--    luaunit.assertEquals( result, "1NaSAH" )
-- end

-- function testFlatHashTable()
--    result = Crimpua.notation({b = 2, a = 1})
--    luaunit.assertEquals( result, "1NaSA2NbSAH" )
-- end

-- function testPlainArrayTable()
--    result = Crimpua.notation({1, "a", 3})
--    luaunit.assertEquals( result, "1N3NaSA" )
-- end

-- in Ruby:
-- Crimp.annotate(["a", 1, ["b", "2"]])
-- => [[[1, "N"], [[["2", "S"], ["b", "S"]], "A"], ["a", "S"]], "A"]
-- function testNestedArrayTable()
--    result = Crimpua.notation({"a", 1, {"b", "2"}})
--    luaunit.assertEquals( result, "1N2SbSAaSA" )
-- end

function testNestedHashTable()
   result = Crimpua.notation({a = {c = 3, d = 2 }})
   luaunit.assertEquals( result, "aS3NcSA2NdSAHAH" )
end

function testSomeNestedHashTable()
   result = Crimpua.notation({b = 1, a = {c = 3, d = 2 }})
   luaunit.assertEquals( result, "aS3NcSA2NdSAHA1NbSAH" )
end

os.exit( luaunit.LuaUnit.run() )
