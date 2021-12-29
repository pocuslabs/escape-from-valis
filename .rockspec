-- escape-from-valis-0.1.rockspec
package = "escape-from-valis"
version = "0.1"
source = {
   url = "https://github.com/pocuslabs/escape-from-valis"
}
description = {
   summary = "A little roguelike game made with LOVE",
   detailed = [[
       Escape from Valis is a little roguelike game in the style of Toejam and Earl.
   ]],
   homepage = "https://github.com/pocuslabs/escape-from-valis", 
   license = "MIT"
}
dependencies = {
   "lua >= 5.1",
   "busted >= 2.0"
}

build = {
   type = "builtin",
   modules = {
      ["main"] = "main.lua"
   }
}