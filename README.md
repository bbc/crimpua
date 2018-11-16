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

## Changelog

### 1.0.0

Initial release.

## Testing

For testing we use [busted](https://olivinelabs.com/busted/).

```sh
luarocks install crimp-1.0.0-0.rockspec --only-deps
luarocks test
```
