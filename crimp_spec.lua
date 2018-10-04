require 'busted.runner'()
Crimpua = require("crimp")

describe("The notation strings", function()
    describe("Given a nil value", function()
        it("returns an underscore", function()
            assert.is_equal("_", Crimpua.notation(nil))
        end)
    end)
    describe("Given a single string", function()
        it("returns the string with an S suffix", function()
            assert.is_equal("abcS", Crimpua.notation("abc"))
        end)
    end)
    describe("Given a single integer", function()
        it("returns the integer with an N siffix", function()
            assert.is_equal("1N", Crimpua.notation(1))
        end)
    end)
    describe("Given a single float", function()
        it("returns the integer with an N siffix", function()
            assert.is_equal("1.2N", Crimpua.notation(1.2))
        end)
    end)
    describe("Given a single true value", function()
        it("returns the string true with a B suffix", function()
            assert.is_equal("trueB", Crimpua.notation(true))
        end)
    end)
    describe("Given a single false value", function()
        it("returns the string true with a B suffix", function()
            assert.is_equal("falseB", Crimpua.notation(false))
        end)
    end)
    describe("Given an array", function()
        it("returns all the notated values with an A suffix", function()
            assert.is_equal("1N3NaSA", Crimpua.notation({1, "a", 3}))
        end)
    end)
--    # Lua tables make no distinction between a table value being nil and the corresponding key not existing in the table
--    # this makes this case unecessary, and not easily matchable in lua
--    # although some users use null = {} and check for null rather than nil to handle this
--    describe("Given an array containing nil", function()
--        it("returns all the notated values with an A suffix", function()
--            assert.is_equal("_1N3NaSA", Crimpua.notation({3, nil, 1, "1"}))
--        end)
--    end)
    describe("Given an array containing capital letters", function()
        it("returns all the notated values with an A suffix", function()
            assert.is_equal("ASBSaSbSA", Crimpua.notation({"a", "A", "b", "B"}))
        end)
    end)
    describe("Given an array containing a nested array", function()
        it("returns all the notated values with an A suffix", function()
            assert.is_equal("1N2SbSAaSA", Crimpua.notation({"a", 1, {"b", "2"}}))
        end)
    end)

end)