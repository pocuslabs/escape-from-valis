local cartographer = require "lib/cartographer"
Object = require "lib/classic"
local const = require "constants"
local spritely = require "spritely"

local function tlen(t)
  local count = 0

  for _ in pairs(t) do
    count = count + 1
  end

  return count
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

local Player = Object:extend()

function Player:new(x, y)
  self.x = x or 1
  self.y = y or 1
  self.dx = 0
  self.dy = 0
end

function Player:isMovable(dx, dy)
  dx = dx or 0
  dy = dy or 0
  local nx = self.x + dx
  local ny = self.y + dy

  local isColliding = P1:isColliding(nx, ny)

  return not isColliding and nx >= 0 and nx <= const.WIDTH and ny >= 0 and ny <= const.HEIGHT
end

function Player:isMoving()
  return self.dx ~= 0 or self.dy ~= 0
end

function Player:setMovement(dx, dy)
  if not P1:isMovable(dx, dy) then
    return
  end

  local nx = P1.x + dx
  local ny = P1.y + dy
  local isColliding = P1:isColliding(nx, ny)

  if isColliding then return end

  P1.dx = dx
  P1.dy = dy
end

function Player:isColliding(x, y)
  if not x or not y then
    x = self.x
    y = self.y
  end

  local corners = {
    { x, y },
    { math.min(x + const.TILE, const.WIDTH), y },
    { x, math.min(const.HEIGHT, y + const.TILE) },
    { math.min(x + const.TILE, const.WIDTH), math.min(const.HEIGHT, y + const.TILE) }
  }

  local isColliding = false
  for _, corner in ipairs(corners) do
    local cx, cy = unpack(corner)
    local layer = Map.layers[1]
    local gid = layer:getTileAtPixelPosition(cx, cy)
    local issolid = Map:getTileProperty(gid, "Solid")
    if issolid then
      isColliding = true
    end
  end

  return isColliding
end

function Player:stepBack()
  self.x = self.ox
  self.y = self.oy
end

function Player:move(dt)
  local speed = const.TILE * const.SPEED * dt
  self.ox = self.x
  self.x = self.x + self.dx * speed
  self.oy = self.y
  self.y = self.y + self.dy * speed
end

local Keys = Object:extend()

function Keys:new()
  self.state = {}
end

function Keys:on(key)
  self.state[key] = true
end

function Keys:off(key)
  self.state[key] = nil
end

Keys.getDirection = function (key)
  if key == "up" then
    return 0, -1
  elseif key == "down" then
    return 0, 1
  elseif key == "left" then
    return -1, 0
  elseif key == "right" then
    return 1, 0
  else
    return 0, 0
  end
end

Keys.isDirection = function (key)
  return key == "up" or key == "down" or key == "left" or key == "right"
end

function love.conf(t)
  t.console = true
end

function love.load()
  love.window.setMode(const.WIDTH, const.HEIGHT)
  Map = cartographer.load("data/map.lua")
  local selector = spritely.load("gfx/blowhard.png", { padding = 0, margin = 0 })
  Spritesheet, PlayerQuad = selector(1, 1)

  P1 = Player()
  KeyState = Keys()
end

function love.update(dt)
  if P1:isMovable() then
    P1:move(dt)
  else
    if P1:isColliding() then
      P1:stepBack()
    end

    P1:setMovement(0, 0)
  end
end

function love.draw()
  Map:draw()
  love.graphics.draw(Spritesheet, PlayerQuad, P1.x, P1.y)
end

function love.keypressed(key, scancode, isrepeat)
  if isrepeat then return end

  KeyState:on(key)

  if P1:isMoving() then return end

  if key == "escape" then
     love.event.quit()
  elseif Keys.isDirection(key) then
    local dx, dy = Keys.getDirection(key)
    P1:setMovement(dx, dy)
  end
end

function love.keyreleased(key, scancode)
  KeyState:off(key)
  print("STATE", tlen(KeyState.state))
  if Keys.isDirection(key) and tlen(KeyState.state) == 0 then
    P1.dx = 0
    P1.dy = 0
  elseif Keys.isDirection(key) and tlen(KeyState.state) > 0 then
    print("HIT")
    local firstKey
    for k in pairs(KeyState.state) do
      firstKey = k
      break
    end
    print("KEY", firstKey)
    local dx, dy = Keys.getDirection(firstKey)
    print("DX,DY", dx, dy)
    P1:setMovement(dx, dy)
  end
end