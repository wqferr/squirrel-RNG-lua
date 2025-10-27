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
   build_variables = {
      CFLAGS="$(CFLAGS)",
      LIBFLAG="$(LIBFLAG)",
      LUA_LIBDIR="$(LUA_LIBDIR)",
      LUA_BINDIR="$(LUA_BINDIR)",
      LUA_INCDIR="$(LUA_INCDIR)",
      LUA="$(LUA)",
   },
   install_variables = {
      INST_PREFIX="$(PREFIX)",
      INST_BINDIR="$(BINDIR)",
      INST_LIBDIR="$(LIBDIR)",
      INST_LUADIR="$(LUADIR)",
      INST_CONFDIR="$(CONFDIR)",
   },
}
