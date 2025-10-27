space=$(eval) $(eval)
ifeq ($(OS),Windows_NT)
	luasrc:=$(subst $(space),\,build sqrl-rng.lua)
	tlsrc:=$(subst $(space),\,src sqrl-rng.tl)
else
	luasrc:=$(subst $(space),/,build sqrl-rng.lua)
	tlsrc:=$(subst $(space),/,src sqrl-rng.tl)
endif

# The all rule is only to be used by my dev PC (which is Windows)
all:
	@lua_modules\bin\cyan.bat build

# The install rule should be used by anyone installing the library, so
# we need to distinguish between OS path separators.
install:
	@cp $(luasrc) $(INST_LUADIR)
	@cp $(tlsrc) $(INST_LUADIR)
