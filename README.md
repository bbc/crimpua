# Crimpua

[![Build Status](https://travis-ci.org/BBC-News/crimpua.svg?branch=master)](https://travis-ci.org/BBC-News/crimpua)

Crimpua is an implementation of [Crimp](https://github.com/BBC-News/crimp) in Lua.

Please see the [bbc-news/crimp](https://github.com/BBC-News/crimp) repo for more details.

## Implementations

[![Crimp Lua](https://img.shields.io/badge/Crimp-Lua-00007C.svg)](https://github.com/bbc-news/crimpua)
[![Crimp Ruby](https://img.shields.io/badge/Crimp-Ruby-CC342D.svg)](https://github.com/bbc-news/crimp)

## Installation

Crimpua can be installed with Luarocks from GitHub:

```sh
luarocks install https://raw.githubusercontent.com/BBC-News/crimpua/v1.0.0-0/crimp-1.0.0-0.rockspec
```

## Usage

```lua
local Crimp = require("crimp")
print(Crimp.signature({a = {b = 1}})) -- prints "ac13c15d07e5fa3992fc6b15113db900"
```

## Lua implementation details

Lua doesn't distinguish between an array and a hash.
They're both tables, but an array is indexed with numbers.

```lua
letters = {'a', 'b', 'c', 'd'}
print(letters) -- prints "table: 0x2119ef0"
print(letters[1]) -- prints "a"
```

We distinguish between an array and a hash by inspecting `table[1]`
which returns the first element for an array and nil for a hash.

You'll see why we have mentioned the use of tables in the next section.

## Implementation Details

Under the hood Crimp annotates the passed data structure to a nested array of primitives (strings, numbers, booleans, nils, etc.) and a single byte to indicate the type of the primitive:

|  Type   | Byte |
|   :-:   |  :-: |
| String  |  `S` |
| Number  |  `N` |
| Boolean |  `B` |
| nil     |  `_` |
| Array   |  `A` |
| Hash    |  `H` |

You can verify it using the `#notation` function:

```lua
Crimp.notation({a=1})
"1NaSAH"
```

Before signing Crimpua, uses the `#notation` function to transform the return value of a table to a string. However the terminal strips away quotes when using LuaJIT (Just-In-Time-Compiler).

```lua
Crimp.notation({ a: { b: 'c' } })
"aSbScSAHAH"
```

Please note the Arrays and Hash keys are sorted before signing.

```lua
Crimp.notation({3, 1, 2})
"1N2N3NA"
```

key/value tuples get sorted as well.

```lua
Crimp.notation({ b: 3 })
"3NbSAH"
```

## Changelog

### 1.0.0-0

Initial release.

## Testing

For testing we use [busted](https://olivinelabs.com/busted/).

```sh
luarocks install crimp-1.0.0-0.rockspec --only-deps
luarocks test
```
