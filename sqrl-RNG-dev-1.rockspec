package = "sqrl-rng"
version = "dev-1"
source = {
   url = "git+https://github.com/wqferr/squirrel-RNG-lua.git"
}
description = {
   homepage = "https://github.com/wqferr/squirrel-RNG-lua",
   license = "MIT"
}
rockspec_format = "3.0"
build = {
   type = "make",
   install_variables = {
      INST_LUADIR="$(LUADIR)"
   }
}
