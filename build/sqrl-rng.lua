local _tl_compat; if (tonumber((_VERSION or ''):match('[%d.]*$')) or 0) < 5.3 then local p, m = pcall(require, 'compat53.module'); if p then _tl_compat = m end end; local ipairs = _tl_compat and _tl_compat.ipairs or ipairs; local math = _tl_compat and _tl_compat.math or math; local _tl_math_maxinteger = math.maxinteger or math.pow(2, 53); local table = _tl_compat and _tl_compat.table or table; local _tl_table_unpack = unpack or table.unpack



































local M = {
   maxval = 0,
}

local int32max = 2147483647
local clamp32
if _tl_math_maxinteger <= int32max then

   M.maxval = _tl_math_maxinteger
   clamp32 = function(v)
      return v
   end
else

   M.maxval = int32max
   clamp32 = function(v)
      return v % (M.maxval + 1)
   end
end
local oneOverMaxval = 1 / M.maxval

local function clamp32_many(...)
   local args = { ... }
   for i, v in ipairs(args) do
      args[i] = clamp32(v)
   end
   return _tl_table_unpack(args)
end

local function mangle(seed, offset)
   local SQ5_BIT_NOISE1 = 0xd2a80a3f
   local SQ5_BIT_NOISE2 = 0xa884f197
   local SQ5_BIT_NOISE3 = 0x6C736F4B
   local SQ5_BIT_NOISE4 = 0xB79F3ABB
   local SQ5_BIT_NOISE5 = 0x1b56c4f5
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

function M.noise(seed, x, y, z, t)
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

function M.noise01(seed, x, y, z, t)
   return M.noise(seed, x, y, z, t) * oneOverMaxval
end

function M.noiseM11(seed, x, y, z, t)
   return 2 * M.noise01(seed, x, y, z, t) - 1
end












local SqrlRng__idx = {
   next = function(self)
      local out = M.noise(self.seed, self.offset)
      self.offset = self.offset + 1
      return out
   end,
   next01 = function(self)
      local out = M.noise01(self.seed, self.offset)
      self.offset = self.offset + 1
      return out
   end,
   nextM11 = function(self)
      local out = M.noiseM11(self.seed, self.offset)
      self.offset = self.offset + 1
      return out
   end,
}
local SqrlRng__meta = {
   __index = SqrlRng__idx,
   __call = function(self)
      return self:next01()
   end,
}

function M.gen(seed)
   return setmetatable(
   { seed = seed, offset = 0 },
   SqrlRng__meta)

end

return M
