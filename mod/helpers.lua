local function rgb(r, g, b)
  return r / 255, g / 255, b / 255
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

local helpers = {
  rgb = rgb,
  every = every,
  tequals = tequals
}

return helpers