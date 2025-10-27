package = "sqrl-RNG"
version = "dev-1"
source = {
   url = "git+https://github.com/wqferr/squirrel-RNG-lua.git"
}
description = {
   homepage = "https://github.com/wqferr/squirrel-RNG-lua",
   license = "MIT"
}
dependencies = {
   queries = {}
}
build_dependencies = {
   queries = {}
}
build = {
   type = "builtin",
   modules = {},
   extra_files = { "build/sqrl-rng.lua" }
}
test_dependencies = {
   queries = {}
}
