local const = require("mod.constants")

local function rgba(r, g, b, a)
  a = a or 1
  return r / 255, g / 255, b / 255, a
end

local function every(t)
  local res = true

  for val in pairs(t) do
    if not val then res = false end
  end

  return res
end

local function tequals(t1, t2)
  if not t1 or not t2 then return nil end

  local elementEquals = {}

  for i, v in ipairs(t1) do
    table.insert(elementEquals, t2[i] == v)
  end

  return every(elementEquals)
end

local function tlen(t)
  local count = 0

  for _ in pairs(t) do
    count = count + 1
  end

  return count
end

local function pixelToTile(x, y)
  print("OtX,OtY", x, y)
  return math.ceil(x / const.TILE_SIZE), math.ceil(y / const.TILE_SIZE)
end

local function tileToPixel(x, y)
  print("OX,OY", x, y)
  return x * const.TILE_SIZE, y * const.TILE_SIZE
end

local helpers = {
  rgba = rgba,
  every = every,
  tequals = tequals,
  tlen = tlen,
  pixelToTile = pixelToTile,
  tileToPixel = tileToPixel
}

return helpers