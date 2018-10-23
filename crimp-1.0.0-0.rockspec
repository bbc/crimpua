package = "crimp"
version = "1.0.0-0"
source = {
  url = "git://github.com/BBC-News/crimpua.git",
  tag = "v1.0.0-0"
}
description = {
  summary = "Crimp for Lua",
  detailed = "Crimp for Lua 5.1+.",
  homepage = "https://github.com/BBC-News/crimpua.git",
  license = "MIT"
}
dependencies = {
  "lua >= 5.1",
  "md5"
}
build = {
  type = "builtin",
  modules = {
    crimp = "crimp.lua"
  }
}