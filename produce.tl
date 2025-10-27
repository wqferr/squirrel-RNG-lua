local sqrl = require "src.sqrl-rng"

local f = io.open("output.vals", "wb")
local args = {...}
local n<const> = tonumber(args[1]) as integer
local g = sqrl.gen(0)

pcall(function()
    for _ = 1, n do
        f:write(string.pack("f", g:nextM11()))
    end
end)

f:close()
