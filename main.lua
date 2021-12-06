local cartographer = require "lib/cartographer"
Object = require "lib/classic"
local const = require "mod/constants"
local spritely = require "mod/spritely"
local Player = require "mod/player"
local Keys = require "mod/keys"

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

  if key == "s" then
    P1:run()
  end

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
  elseif key == "s" then
    P1:walk()
  end
end
