local rng = require "src.sqrl-rng"

print(rng.maxval)

local f = io.open("output.vals", "wb")
local args = {...}
local n<const> = tonumber(args[1]) as integer

pcall(function()
    for i = 1, n do
        f:write(string.pack("f", rng.noiseM11(0, i)))
    end
end)

f:close()
