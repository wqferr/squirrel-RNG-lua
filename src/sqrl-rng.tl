------------------------------------------------------------------------------------------------
-- SquirrelNoise5 - Squirrel's Raw Noise utilities (version 5)
--
-- This code is made available under the Creative Commons attribution 3.0 license (CC-BY-3.0 US):
--	Attribution in source code comments (even closed-source/commercial code) is sufficient.
--	License summary and text available at: https://creativecommons.org/licenses/by/3.0/us/
--
-- These noise functions were written by Squirrel Eiserloh as a cheap and simple substitute for
--	the [sometimes awful] bit-noise sample code functions commonly found on the web, many of which
--	are hugely biased or terribly patterned, e.g. having bits which are on (or off) 75% or even
--	100% of the time (or are excessively overkill/slow for our needs, such as MD5 or SHA).
--
-- Note: This is work in progress; not all functions have been tested.  Use at your own risk.
--	Please report any bugs, issues, or bothersome cases to wqferr at gmail.com.
--
-- The following functions are all based on a simple bit-noise hash function which returns an
--	uingeger containing 32 reasonably-well-scrambled bits, based on a given (signed)
--	integer input parameter (position/index) and [optional] seed.  Kind of like looking up a
--	value in an infinitely large [non-existent] table of previously rolled random numbers.
--
-- These functions are deterministic and random-access / order-independent (i.e. state-free),
--	so they are particularly well-suited for use in smoothed/fractal/simplex/Perlin noise
--	functions and out-of-order (or or-demand) procedural content generation (i.e. that mountain
--	village is the same whether you generated it first or last, ahead of time or just now).
--
-- The N-dimensional variations simply hash their multidimensional coordinates down to a single
--	32-bit index and then proceed as usual, so while results are not unique they should
--	(hopefully) not seem locally predictable or repetitive.
--
-- Note from Lua port of C++ Code: This code originally used 32-bit unsigned integers for seeds,
--  which are unsupported in Lua. For this reason, extremely large values for seeds and offsets are
--  UNTESTED! This module will lead to undefined behavior if integers are of any size smaller than
--  4 bytes long.
--
------------------------------------------------------------------------------------------------

local M = {
    maxval: integer = 0
}

local int32max = 2147483647
local clamp32: function(integer): integer
if math.maxinteger <= int32max then
    -- No need to clamp, just return itself
    M.maxval = math.maxinteger
    clamp32 = function(v: integer): integer
        return v
    end
else
    -- If we dont mod it, it could break and repeat
    M.maxval = int32max
    clamp32 = function(v: integer): integer
        return v % (M.maxval+1)
    end
end
local oneOverMaxval = 1 / M.maxval
print(oneOverMaxval)

local function clamp32_many(...: integer): integer...
    local args = {...}
    for i, v in ipairs(args) do
        args[i] = clamp32(v)
    end
    return table.unpack(args)
end

local function mangle(seed: integer, offset: integer): integer
    local SQ5_BIT_NOISE1<const> = 0xd2a80a3f -- 11010010101010000000101000111111
    local SQ5_BIT_NOISE2<const> = 0xa884f197 -- 10101000100001001111000110010111
    local SQ5_BIT_NOISE3<const> = 0x6C736F4B -- 01101100011100110110111101001011
    local SQ5_BIT_NOISE4<const> = 0xB79F3ABB -- 10110111100111110011101010111011
    local SQ5_BIT_NOISE5<const> = 0x1b56c4f5 -- 00011011010101101100010011110101
    local mangledBits = offset

    mangledBits = mangledBits * SQ5_BIT_NOISE1 + seed
    mangledBits = mangledBits ~ (mangledBits >> 9)

    mangledBits = mangledBits + SQ5_BIT_NOISE2
    mangledBits = mangledBits ~ (mangledBits >> 11)
    mangledBits = mangledBits * SQ5_BIT_NOISE3
    mangledBits = mangledBits ~ (mangledBits >> 13)

    mangledBits = mangledBits + SQ5_BIT_NOISE4
    mangledBits = mangledBits ~ (mangledBits >> 15)
    mangledBits = mangledBits * SQ5_BIT_NOISE5
    mangledBits = mangledBits ~ (mangledBits >> 17)

    return clamp32(mangledBits)
end

function M.noise(seed: integer, x: integer, y?: integer, z?: integer, t?: integer): integer
    seed, x, y, z, t = clamp32_many(seed, x, y, z, t)
    local offset = x
    if y then
        offset = offset + 198491317 * y
    end
    if z then
        offset = offset + 6542989 * z
    end
    if t then
        offset = offset + 357239 * t
    end
    return mangle(seed, offset)
end

function M.noise01(seed: integer, x: integer, y?: integer, z?: integer, t?: integer): number
    return M.noise(seed, x, y, z, t) * oneOverMaxval
end

function M.noiseM11(seed: integer, x: integer, y?: integer, z?: integer, t?: integer): number
    return 2 * M.noise01(seed, x, y, z, t) - 1
end

local record PRNG
    state: integer

    -- TODO
end

return M
